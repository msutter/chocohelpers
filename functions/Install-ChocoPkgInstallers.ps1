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
        [Parameter(Mandatory=$false)]
        [HashTable[]]
        $Installers = $script:Installers,

        [Parameter(Mandatory=$false)]
        [String]
        $FilesPath = $script:FilesPath,

        [Parameter(Mandatory=$false)]
        [String]
        $PackageId = $script:PackageId
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

        # Start the install Process
        Write-Verbose "FilesPath: ${FilesPath}"

        Write-Verbose "PackageId: ${PackageId}"
        Write-Verbose "InstallerExtension: ${InstallerExtension}"
        Write-Verbose "Installer Args: $($(Installer['Args']))"
        Write-Verbose "InstallerPath: ${InstallerPath}"

        Install-ChocolateyPackage $PackageId $InstallerExtension $Installer['Args'] "${InstallerPath}"

    }

}

