function Install-ChocoPkgFiles
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
    $SortedItems = $Items | Sort -Property TargetPath

    if (!([string]::IsNullOrEmpty($Prefix))) {

        # Create the prefix path
        if (!(Test-Path -path "${Prefix}")) {
            Write-ChocolateyFailure $PackageId "${Prefix} (Prefix) must exist ! "
            throw
        }

        foreach ($item in $SortedItems)
        {
            Write-Verbose "Installing $($item.TargetPath) ($($item.ItemType))"

            if ($item.ItemType -eq 'directory') {
                $null = New-Item -Type Directory "$($item.TargetPath)"
            } else {
                $null = Copy-Item -Force "$($item.SourcePath)" "$($item.TargetPath)"
            }
        }
    }

}

