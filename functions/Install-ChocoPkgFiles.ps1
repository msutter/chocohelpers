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
        [Parameter(Mandatory=$true)]
        [String]
        $Prefix,

        [Parameter(Mandatory=$true)]
        [String]
        $FilesPath,

        [Parameter(Mandatory=$true)]
        [String]
        $PackageId
    )

    $VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference')
    $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')

    $callstack = Get-PSCallStack
    Write-Verbose "Calling script: $($callstack[1].Location)"

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
                $null = New-Item -Type -Force Directory "$($item.TargetPath)"
            } else {
                $null = Copy-Item -Force "$($item.SourcePath)" "$($item.TargetPath)"
            }
        }
    }

}

