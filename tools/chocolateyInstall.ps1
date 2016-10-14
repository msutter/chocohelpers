$packageName = "chocoHelpers"
$moduleName = "chocoHelpers"

$installDir   = Join-Path $PSHome "Modules"
$installPath  = Join-Path $installDir $modulename
$myDir        = Split-Path -Parent $MyInvocation.MyCommand.Path
$pkgpath      = (get-item $myDir).parent.FullName
$psmodulepath = "$pkgpath/files"

if(Test-Path -Path "${installPath}"){
  $null = Remove-Item -Force -Recurse $installPath
}

$null = Copy-Item $psmodulepath $installPath -Force -Recurse
