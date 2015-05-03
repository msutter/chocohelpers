function Get-ChocoPkgItems
{
    <#
        .SYNOPSIS
        Short Description
        .DESCRIPTION
        Detailed Description
        .EXAMPLE
        Get-PkgFilesList
        explains how to use the command
        can be multiple lines
        .EXAMPLE
        Get-PkgFilesList
        another example
        can have as many examples as you like
    #>
    [CmdletBinding()]
    # param
    # (
    #     [Parameter(Mandatory=$true)]
    #     [String]
    #     $Prefix,

    #     [Parameter(Mandatory=$true)]
    #     [String]
    #     $FilesPath
    # )

    $PkgItems  = New-Object System.Collections.ArrayList

    foreach ($item in (Get-ChildItem -Path $FilesPath -Recurse))
    {
        if ($item.PSIsContainer) {
            $ItemType = 'directory'
        } else {
            $ItemType = 'file'
        }

        $SourcePath = $item.FullName
        $TargetPath = ($SourcePath -replace [regex]::Escape($FilesPath), "${Prefix}")
        $PkgItem = New-ChocoPkgItem -SourcePath $SourcePath -TargetPath $TargetPath -ItemType $ItemType
        $trash = $PkgItems.add($PkgItem)
    }

    return $PkgItems
}
