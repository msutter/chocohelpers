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
        [String]$FilesDirectoryName = 'files',

        [Parameter(Mandatory=$false)]
        [String]$PartsDirectoryName = 'parts'
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
  $PartsPath = Join-Path $PackagePath $PartsDirectoryName

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

  # Define Parts merge dir

  $ChocolateyPartsPath = Join-Path $env:ChocolateyInstall 'parts'
  $PackagePartsMergePath = Join-Path $ChocolateyPartsPath "${PackageId}.${PackageVersion}"

  switch ($CallingScriptName) {
    'chocolateyInstall.ps1' {
      #------- DEPLOY/MERGE ZIP PARTS WHEN PARTS PRESENT ---------#
      if (Test-Path -Path "${PartsPath}") {
        # Add merge path if absent
        if (!(Test-Path -Path "${PackagePartsMergePath}")) {
          $null = New-Item -ItemType Directory $PackagePartsMergePath
        }

        # Add Zip part to merge dir
        Write-Verbose "Adding zip part to ${PackagePartsMergePath}"
        $null = Get-ChildItem $PartsPath | Copy-Item -Destination $PackagePartsMergePath

        if ("${PackageId}" -eq (Split-Path $PackagePath -Leaf)) {
          Write-Verbose "Merge Parts to Files"
          ConvertFrom-ZipParts "$PackagePartsMergePath\Files.zip" "$PackagePartsMergePath\Files"

          # # Override FilesPath variable
          # $FilesPath = Join-Path $PackagePartsMergePath "Files"

          # symlink the extracted FILES directory
          $MergedFilesPath = Join-Path $PackagePartsMergePath "Files"
          $null = cmd.exe /c mklink /D $FilesPath $MergedFilesPath
        }
      }

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
      if (Test-Path -Path "${PartsPath}") {
        # Override FilesPath variable
        $FilesPath = Join-Path $PackagePartsMergePath "Files"
      }

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

      #------- CLEAN ZIP PARTS WHEN PARTS PRESENT ---------#
      if (Test-Path -Path "${PartsPath}") {

        # Remove Zip part from merge dir
        Write-Verbose "Remove zip part from ${PackagePartsMergePath}"
        $ZipPartNames = Get-ChildItem -Name $PartsPath
        foreach ($ZipPartName in $ZipPartNames) {
          Remove-Item (Join-Path $PackagePartsMergePath $ZipPartName)
        }

        if ("${PackageId}.${PackageVersion}" -eq (Split-Path $PackagePath -Leaf)) {

          Write-Host "* Cleaning up part packages" -foreground green -background black
          # Get all part sub packages
          $chocolateyLib = Join-Path $env:ChocolateyInstall 'lib'
          $LibSubPartPackages = Get-ChildItem $chocolateyLib | Where-Object {$_.name -like "${PackageId}-part*${PackageVersion}"}
          $LibSubPartPackages | Remove-Item -Force -Recurse
          Write-Host "* Done" -foreground green -background black
          # Remove all zip parts
          Remove-Item -Recurse -Force "$PackagePartsMergePath"
        }
      }

    } # chocolateyUninstall.ps1
  } # switch
}