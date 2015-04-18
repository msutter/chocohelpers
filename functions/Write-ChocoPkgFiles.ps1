function Write-ChocoPkgFiles
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
    param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [System.Object]
        $ChocoPkgData,

        [Parameter(Mandatory=$false, Position=1)]
        [switch]
        $Uninstall
    )

    $Items = Get-ChocoPkgItems $ChocoPkgData

    if ($Uninstall) {
        $SortedItems = $Items | Sort -Property TargetPath -Descending
    } else {
        $SortedItems = $Items | Sort -Property TargetPath
    }

    foreach ($item in $SortedItems) {
        Write-Verbose "$($item.TargetPath) ($($item.ItemType))"
    }

}
