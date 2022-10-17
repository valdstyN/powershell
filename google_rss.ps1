cls
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass -Force;

$headers = @{
    'Content-Type' = 'application/json'    
}

$uri = 'https://news.google.com/rss'
$r = Invoke-RestMethod -Method Get -Uri $uri -Headers $headers
$c = 0
ForEach($n in $r){
    $c++
    Write-Output ($c.ToString()+' '+$n.title)
}
while(1){
    $id = Read-Host ">> Read news #?"
    Start-Process $r.Get(([int]$id)-1).link
}
pause