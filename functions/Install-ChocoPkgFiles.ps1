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
    param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [System.Object]
        $ChocoPkgData
    )

    $Items = Get-ChocoPkgItems $ChocoPkgData
    $SortedItems = $Items | Sort -Property TargetPath

    if (!([string]::IsNullOrEmpty($ChocoPkgData.Prefix))) {

        # Create the prefix path
        if (!(Test-Path -path $ChocoPkgData.Prefix)) {
            Write-ChocolateyFailure $ChocoPkgData.PackageId "$($ChocoPkgData.Prefix) (Prefix) must exist ! "
            throw
        }

        foreach ($item in $SortedItems)
        {
            Write-Verbose "Installing $($item.TargetPath) ($($item.ItemType))"

            if ($item.ItemType -eq 'directory') {
                $Trash = New-Item -Force -Type Directory $item.TargetPath
            } else {
                $Trash = Copy-Item -Force $item.SourcePath $item.TargetPath
            }
        }
    }

}

