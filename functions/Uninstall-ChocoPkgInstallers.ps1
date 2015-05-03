function Uninstall-ChocoPkgUninstallers
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
    #     $Uninstallers,

    #     [Parameter(Mandatory=$true)]
    #     [String]
    #     $PackageId,

    #     [Parameter(Mandatory=$true)]
    #     [String]
    #     $FilesPath
    # )

    foreach ($Uninstaller in $Uninstallers)
    {

        if ($Uninstaller.ContainsKey('WMI')) {
            # if there is no special Uninstaller Command use the windows wmi object to uninstall

            # Get the right wmi object
            $Product = Get-WmiObject -Class Win32_Product | Where-Object {$_.name -like "$($Uninstaller.WMI)*"}

            if($Product -and $Product.GetType().name -eq "ManagementObject"){

                # if wmi object is found, try to uninstall it

                # set ProductId
                $ProductId = $Product.identifyingNumber

                # set Uninstall Args
                $UninstallArgs = "/uninstall $ProductId $($Uninstaller.Args)"

                # uninstall the vwm object
                Start-Process -FilePath msiexec -ArgumentList "${UninstallArgs}" -Wait

            } else {

                # else write an error
                Write-ChocolateyFailure "$PackageId" "Product: $($Uninstaller.WMI) Not Found"
                throw
            }

        } elseif ($Uninstaller.ContainsKey('File')) {
            # else use the specific uninstaller
            & "$($Uninstaller.File)" $Uninstaller.Args
        }

    }

}