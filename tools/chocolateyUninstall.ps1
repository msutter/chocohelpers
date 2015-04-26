$packageName = "chocoHelpers"
$moduleName = "chocoHelpers"

try {
  $installPath = Join-Path $PSHome  "Modules\$modulename"
  Remove-Item -Recurse -Force $installPath
  Write-ChocolateySuccess "$packageName"
} catch {
  Write-ChocolateyFailure "$packageName" $($_.Exception.Message)
  throw
}
