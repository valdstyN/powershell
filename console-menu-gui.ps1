function Display-Menu($selected){
    CLS
    write-Host ""
    foreach($m in $menu){
        if($m -eq $selected){
            Write-Host " " -NoNewline
            Write-Host " $m " -foregroundColor DarkBlue -backgroundColor White
        }else{
            Write-Host " " -NoNewline
            Write-Host " $m " -foregroundColor White -backgroundColor DarkBlue
        }
    }
}

function Enter-Menu($selected){
    CLS
    Write-Host $selected
   
}

function Move-Menu($cur,$dir){
    $i = $menu.IndexOf($selected)
    $ni = $i - [int]$dir
    if($ni -ne -1 -and $ni -ne $menu.Length){
       $selected = $menu[$ni]
    }
    return $selected
}

$menu = @(
  "Option A"
  "Option B"
  "Option C"
  "Option D"
)

$selected = "Option A"
$loop = 1

Display-Menu $selected

while($loop -eq 1){
    $k =  ([console]::ReadKey()).Key
    switch($k){
      "UpArrow" { 
        $selected = Move-Menu $selected "1"
        Display-Menu $selected
      }
      "DownArrow" {
        $selected = Move-Menu $selected "-1" 
        Display-Menu $selected
      }
      "Enter" { Enter-Menu $selected }
      "Escape" { $loop = 0 }
    }
}