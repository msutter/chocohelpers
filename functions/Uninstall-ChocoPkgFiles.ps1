function Uninstall-ChocoPkgFiles
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
        [String]
        $Prefix = $script:Prefix,

        [Parameter(Mandatory=$false)]
        [String]
        $FilesPath = $script:FilesPath,

        [Parameter(Mandatory=$false)]
        [String]
        $PackageId = $script:PackageId
    )

    $Items = Get-ChocoPkgItems -Prefix $Prefix -FilesPath $FilesPath
    $SortedItems = $Items | Sort -Property TargetPath -Descending

    if (!([string]::IsNullOrEmpty($Prefix))) {
        foreach ($item in $SortedItems)
        {
            Write-Verbose "Uninstalling $($item.TargetPath) ($($item.ItemType))"
            if ($item.ItemType -eq 'directory') {
                # check if directory is empty
                if ((Get-ChildItem "$($item.TargetPath)").Count -gt 0) {
                    # Directory is not empty, do not remove, but warn
                    Write-Warning "$($item.TargetPath) is not empty ! Skipping deletion"
                } else {
                    # Directory is empty, removing it
                    $null = Remove-Item "$($item.TargetPath)"
                }

            } else {
                $null = Remove-Item "$($item.TargetPath)"
            }

        }
    }

}

