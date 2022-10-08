$file = Read-Host "Input file? "
$what = Read-Host "Find what? "
$by = Read-Host "Replace with? "
$dat = Get-Date -Format yyyyMMddHHmmss
$c = (Get-Content ($pwd.Path+'\'+$file)) -replace $what, $by > ($pwd.Path+'\'+$file+$dat+'.txt')
Write-Output $c