function Uninstall-ChocoPkgUninstallers
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
        $Uninstallers = $script:Uninstallers,

        [Parameter(Mandatory=$false)]
        [String]
        $FilesPath = $script:FilesPath,

        [Parameter(Mandatory=$false)]
        [String]
        $PackageId = $script:PackageId
    )

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