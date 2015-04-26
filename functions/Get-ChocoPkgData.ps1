function Get-ChocoPkgData
{
    <#
        .SYNOPSIS
        Short Description
        .DESCRIPTION
        Detailed Description
        .EXAMPLE
        Get-ChocoPkgData
        explains how to use the command
        can be multiple lines
        .EXAMPLE
        Get-ChocoPkgData
        another example
        can have as many examples as you like
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

    # # Pathes Validations
    # $PackagePathExists = Test-Path $PackagePath
    # $FilesPathExists   = Test-Path $FilesPath
    # $ToolsPathExists   = Test-Path $ToolsPath

    # if (!([string]::IsNullOrEmpty($ChocoPkgData.Prefix))) {
    #   $PrefixPathValid   = Test-Path -IsValid $ChocoData.Prefix
    # }

    # Add Package Path to datas
    $trash = $ChocoData.Add('PackagePath', $PackagePath)

    # Add tools path to datas
    $trash = $ChocoData.Add('ToolsPath', $ToolsPath)

    # Add files path to datas
    $trash  = $ChocoData.Add('FilesPath', $FilesPath)

    $PkgData = New-Object -TypeName PSObject -Prop $ChocoData
    return $PkgData
}

