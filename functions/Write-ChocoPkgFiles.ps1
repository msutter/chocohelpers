function Write-ChocoPkgFiles
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
        $Prefix,

        [Parameter(Mandatory=$true)]
        [String]
        $FilesPath,

        [Parameter(Mandatory=$false, Position=1)]
        [switch]
        $Uninstall
    )

    $Items = Get-ChocoPkgItems -Prefix $Prefix -FilesPath $FilesPath

    if ($Uninstall) {
        $SortedItems = $Items | Sort -Property TargetPath -Descending
    } else {
        $SortedItems = $Items | Sort -Property TargetPath
    }

    foreach ($item in $SortedItems) {
        Write-Verbose "$($item.TargetPath) ($($item.ItemType))"
    }

}
