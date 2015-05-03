function Install-ChocoPkgFiles
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
    #     [String]
    #     $Prefix,

    #     [Parameter(Mandatory=$true)]
    #     [String]
    #     $PackageId,

    #     [Parameter(Mandatory=$true)]
    #     [String]
    #     $FilesPath
    # )

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
                $null = New-Item -Force -Type Directory "$($item.TargetPath)"
            } else {
                $null = Copy-Item -Force "$($item.SourcePath)" "$($item.TargetPath)"
            }
        }
    }

}

