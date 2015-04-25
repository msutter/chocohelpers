function New-ChocoManifest
{
    <#
        .SYNOPSIS
        Short Description
        .DESCRIPTION
        Detailed Description
    #>
    [CmdletBinding()]
    Param
    (
        # Specifies the nuspec files to update
        [ValidateScript( { Test-Path($_) } )]
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true )]
        [string]$ToolsDirectory = './tools',

        [Parameter(Mandatory = $false)]
        [string]$FileName = 'chocolatey.psd1',

        [Parameter(Mandatory = $false)]
        [string]$PackageId,

        [Parameter(Mandatory = $false)]
        [string]$PackageVersion,

        [Parameter(Mandatory = $false)]
        [string]$Prefix
    )

    if ([System.IO.Path]::IsPathRooted($ToolsDirectory)) {
        $AbsToolsDirectory = $ToolsDirectory
    } else {
        $AbsToolsDirectory = Join-Path (Get-Location) -ChildPath $ToolsDirectory
    }

    $FilePath = Join-Path -Path $ToolsDirectory -ChildPath $FileName

    $Manifest = "# Chocolatey Package Manifest
@{

  # Package Id as specified in the nuspec file
  PackageId = `"${PackageId}`"

  # Package Version as specified in the nuspec file
  #PackageVersion = `"${PackageVersion}`"

  # ------- FILES INSTALL -------- #
  # Install location of files in the files directory. (the path to prefix files with when installing)
  #
  # This path must exists !
  #   if not create it in the chocolateyBeforeInstall.ps1 script
  #   also remove it in the chocolateyAfterUninstall.ps1 script
  Prefix = `"${Prefix}`"

}
"

    $Manifest | Out-File $FilePath

}