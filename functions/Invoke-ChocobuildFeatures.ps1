function Invoke-ChocoBuildFeatures
{
<#
    .SYNOPSIS

    .DESCRIPTION

    .EXAMPLE

#>
  [CmdletBinding()]
  param(
        [Parameter(Mandatory=$false)]
        [String]$FilesDirectoryName = 'files'
  )

  $VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference')
  $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')

  # Get the calling script
  $CallStack = Get-PSCallStack
  $CallingScriptPath = "$($callstack[1].ScriptName)"
  $CallingScriptName = Split-Path -Leaf $CallingScriptPath

  # Get the location of the package on disk
  $ToolsPath = Split-Path -Parent $CallingScriptPath
  $PackagePath = Split-Path -Parent $ToolsPath
  $FilesPath = Join-Path $PackagePath $FilesDirectoryName

  # Load Package variables (datas)
  $ChocoManifest = Get-ChocoManifest -ToolsPath "${ToolsPath}"

  # Add the datas as local variable
  Write-Verbose '------- Variable you can use in the chocospec script ---------'
  Write-Verbose "PackagePath: ${PackagePath}"
  Write-Verbose "ToolsPath: ${ToolsPath}"
  Write-Verbose "FilesPath: ${FilesPath}"
  foreach ($Var in $ChocoManifest.Keys) {
      Write-Verbose "${Var}: $($ChocoManifest.$Var)"
      # Pathes with spaces workaround
      if ($ChocoManifest.$Var -is [system.string]) {
          Set-Variable -Name $Var -Value "$($ChocoManifest.$Var)"
      } else {
          Set-Variable -Name $Var -Value $ChocoManifest.$Var
      }
  }
  Write-Verbose '--------------------------------------------------------------'

  switch ($CallingScriptName) {
    'chocolateyInstall.ps1' {
      #------- EXECUTE BEFORE-INSTALL SCRIPT WHEN PRESENT ---------#
      $BeforeInstallPath = "${ToolsPath}\chocolateyBeforeInstall.ps1"
      if (Test-Path -Path "${BeforeInstallPath}") {
        Write-Verbose "Executing ${BeforeInstallPath}"
        & "${BeforeInstallPath}" -Verbose
      }

      #------- INSTALLATION SETUP (Only files deployement here ) ---------#
      if ( Test-Path variable:Prefix ) {
        Install-ChocoPkgFiles `
          -Prefix $Prefix `
          -FilesPath $FilesPath `
          -PackageId $PackageId
      }

      #------- EXECUTE AFTER-INSTALL SCRIPT ---------#
      $AfterInstallPath = "${ToolsPath}\chocolateyAfterInstall.ps1"
      if (Test-Path -Path "${AfterInstallPath}") {
        Write-Verbose "Executing ${AfterInstallPath}"
        & "${AfterInstallPath}" -Verbose
      } else {
        # Default install of exe, msi, etc...
        Install-ChocoPkgInstallers `
          -Installers $Installers `
          -FilesPath $FilesPath `
          -PackageId $PackageId
      }
    } # chocolateyUninstall.ps1

    'chocolateyUninstall.ps1' {

      #------- UNINSTALLATION -------#
      #------- BEFORE UNINSTALL SCRIPT ---------#
      $BeforeUninstallPath = "${ToolsPath}\chocolateyBeforeUninstall.ps1"
      if (Test-Path -Path "${BeforeUninstallPath}") {
        Write-Verbose "Executing ${BeforeUninstallPath}"
        & "${BeforeUninstallPath}"
      } else {
        # Default uninstall of exe, msi, etc...
        Uninstall-ChocoPkgUninstallers `
          -Uninstallers $Uninstallers `
          -FilesPath $FilesPath `
          -PackageId $PackageId
      }

      #------- UNINSTALLATION SETUP ---------#
      if ( Test-Path variable:Prefix ) {
        Uninstall-ChocoPkgFiles `
          -Prefix $Prefix `
          -FilesPath $FilesPath `
          -PackageId $PackageId
      }

      #------- AFTER UNINSTALL SCRIPT ---------#
      $AfterUninstallPath = "${ToolsPath}\chocolateyAfterUninstall.ps1"
      if (Test-Path -Path "${AfterUninstallPath}") {
        Write-Verbose "Executing ${AfterUninstallPath}"
        & "${AfterUninstallPath}"
      }
    } # chocolateyUninstall.ps1
  } # switch
}