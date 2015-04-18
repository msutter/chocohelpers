function New-ChocoPkgItem {
    param(
          [Parameter(Mandatory=$true)]
          [String]$SourcePath,
          [Parameter(Mandatory=$true)]
          [string]$TargetPath,
          [Parameter(Mandatory=$true)]
          [ValidateSet('file','directory')]
          [String]$ItemType
    )
    New-Object psobject -property @{
        SourcePath = $SourcePath
        TargetPath = $TargetPath
        ItemType   = $ItemType
    }

}