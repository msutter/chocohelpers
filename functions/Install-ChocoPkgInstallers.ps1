function Install-ChocoPkgInstallers
{
    <#
        .SYNOPSIS
        Short Description
        .DESCRIPTION
        Detailed Description
        .EXAMPLE
        Install-ChocoPkgFiles
        explains how to use the command
        can be multiple lines
        .EXAMPLE
        Install-ChocoPkgFiles
        another example
        can have as many examples as you like
    #>
    [CmdletBinding()]
    # param
    # (
    #     [Parameter(Mandatory=$true)]
    #     [HashTable]
    #     $Installers,

    #     [Parameter(Mandatory=$true)]
    #     [String]
    #     $PackageId,

    #     [Parameter(Mandatory=$true)]
    #     [String]
    #     $FilesPath
    # )

    foreach ($Installer in $Installers)
    {

        Write-Verbose "Installing $($Installer.File)"

        # get install setup extension
        $InstallerExtension = $Installer.File.split('.')[-1]

        if ([System.IO.Path]::IsPathRooted("$($Installer.File)")) {
            $InstallerPath = "$($Installer.File)"
        } else {
            $InstallerPath = Join-Path "${FilesPath}" "$($Installer.File)"
        }

        # Start the install Process
        Install-ChocolateyPackage $PackageId $InstallerExtension $Installer['Args'] "${InstallerPath}"

    }

}

