function Import-ChocoHelpersVariables
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
        $PackagePath,

        [Parameter(Mandatory=$false, Position=1)]
        [System.String]
        $ToolsFolderName = 'tools',

        [Parameter(Mandatory=$false, Position=2)]
        [System.String]
        $FilesFolderName = 'files',

        [Parameter(Mandatory=$false, Position=2)]
        [System.String]
        $ChocoManifestFileName = 'chocolatey.psd1'
    )

    $FilesPath         = Join-Path $PackagePath $FilesFolderName
    $ToolsPath         = Join-Path $PackagePath $ToolsFolderName
    $ChocoManifestPath = Join-Path $ToolsPath $ChocoManifestFileName

    # Load Data from chocolatey.psd1
    $ChocoData = Get-Content $ChocoManifestPath | Out-String | iex

    # Add tools path to datas
    $null = $ChocoData.Add('ToolsPath', $ToolsPath)

    # Add files path to datas
    $null = $ChocoData.Add('FilesPath', $FilesPath)

    # Add the datas as local variable in the calling scope ( -scope 1 )
    foreach ($Var in $ChocoData.Keys) {
        Write-Verbose "Importing variable $($ChocoData.$Var) in the script scope"

        # Pathes with spaces workaround
        if ($ChocoData.$Var -is [system.string]) {
            New-Variable -Name $Var -Value "$($ChocoData.$Var)" -Scope Script
        } else {
            New-Variable -Name $Var -Value $ChocoData.$Var -Scope Script
        }
    }

    return $ChocoData

}

