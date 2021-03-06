function Install-ChocoPkgInstallers
{
<#
    .SYNOPSIS

    .DESCRIPTION

    .EXAMPLE

#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [String]
        $FilesPath,

        [Parameter(Mandatory=$true)]
        [String]
        $PackageId,

        [Parameter(Mandatory=$false)]
        [HashTable[]]
        $Installers = @()
    )

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

        Install-ChocolateyInstallPackage $PackageId $InstallerExtension $Installer.Args "${InstallerPath}"

    }

}

