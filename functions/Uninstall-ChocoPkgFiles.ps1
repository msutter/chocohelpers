function Uninstall-ChocoPkgFiles
{
    <#
        .SYNOPSIS
        Short Description
        .DESCRIPTION
        Detailed Description
        .EXAMPLE
        Uninstall-ChocoPkgFiles
        explains how to use the command
        can be multiple lines
        .EXAMPLE
        Uninstall-ChocoPkgFiles
        another example
        can have as many examples as you like
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [System.Object]
        $ChocoPkgData
    )

    $Items = Get-ChocoPkgItems $ChocoPkgData
    $SortedItems = $Items | Sort -Property TargetPath -Descending

    if (!([string]::IsNullOrEmpty($ChocoPkgData.Prefix))) {
        foreach ($item in $SortedItems)
        {
            Write-Verbose "Uninstalling $($item.TargetPath) ($($item.ItemType))"
            Remove-Item -Force $item.TargetPath
        }
    }

}

