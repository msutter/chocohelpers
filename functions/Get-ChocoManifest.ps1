function Get-ChocoManifest
{
<#
    .SYNOPSIS

    .DESCRIPTION

    .EXAMPLE

#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [System.String]
        $ToolsPath,

        [Parameter(Mandatory=$false, Position=2)]
        [System.String]
        $ChocoManifestFileName = 'chocolatey.psd1'
    )

    $ChocoManifestPath = Join-Path $ToolsPath $ChocoManifestFileName

    # Load Data from chocolatey.psd1
    $ChocoData = Get-Content $ChocoManifestPath | Out-String | iex

    Return $ChocoData
}

