function Get-ChocoPkgItems
{
<#
    .SYNOPSIS

    .DESCRIPTION

    .EXAMPLE

#>
    [CmdletBinding()]
    param
    (
        # [Parameter(Mandatory=$false)]
        # [String]
        # $Prefix = $script:Prefix,

        # [Parameter(Mandatory=$false)]
        # [String]
        # $FilesPath = $script:FilesPath
    )

    $PkgItems  = New-Object System.Collections.ArrayList

    foreach ($item in (Get-ChildItem -Path "${FilesPath}" -Recurse))
    {
        if ($item.PSIsContainer) {
            $ItemType = 'directory'
        } else {
            $ItemType = 'file'
        }

        $SourcePath = $item.FullName
        $TargetPath = ($SourcePath -replace [regex]::Escape("${FilesPath}"), "${Prefix}")
        $PkgItem    = New-ChocoPkgItem -SourcePath "${SourcePath}" -TargetPath "${TargetPath}" -ItemType $ItemType
        $null       = $PkgItems.add($PkgItem)
    }

    return $PkgItems
}
