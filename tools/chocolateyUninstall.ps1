$packageName = "chocoHelpers"
$moduleName = "chocoHelpers"

$installDir   = Join-Path $PSHome "Modules"
$installPath  = Join-Path $installDir $modulename
$null = Remove-Item -Recurse $installPath