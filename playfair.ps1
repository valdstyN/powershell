cls

$key = Read-Host "Key"
$board = 1,2,3,4,5,6,7
$map = "abcdefghijklmnopqrstuvwxyz0123456789♂@.,?!:/+-*()"
$i = 0
$nKey = ""
$cypher = "";

# prepare the hashmap
for($c = 0;$c -lt $key.Length;$c++){
    $char = $key.Substring($c,1)
    $map = $map.Replace($char,'')
}
$map = $key+$map

# generate board
for($y = 0; $y -lt 7; $y++){
    $board[$y] = 1,2,3,4,5,6,7
    for($x = 0; $x -lt 7; $x++){
       $board[$y][$x] = $map.Substring($i,1)
       $i++
    }
    Write-Output (-join $board[$y])
}

$what = 'e'
while($what -eq 'e' -or $what -eq 'd'){
$what = Read-Host "[E]ncrypt or [D]ecrypt"
$what = $what.ToLower()
$cypher = "";
$data = Read-Host "String"
$data = $data.ToLower()

$data = $data -replace (' ','♂')
if($data.Length%2 -eq 1){
    $data=-join ($data,'♂')
}

for($p = 0; $p -lt $data.Length; $p+=2){
            $c1 = $data[$p]
            $c2 = $data[$p+1]
            $c1y = [math]::Truncate(($map.IndexOf($c1))/7)
            $c2y = [math]::Truncate(($map.IndexOf($c2))/7)
            $c1x = ($map.IndexOf($c1)%7)
            $c2x = ($map.IndexOf($c2)%7)
            if($c1y -eq $c2y -and $c1x -eq $c2x){
                if($what -eq 'e'){
                    if($c1x+1 -eq 7){$c1x=-1}
                    if($c2x+1 -eq 7){$c2x=-1}
                    $c1 = $board[$c1y][$c1x+1]
                    $c2 = $board[$c2y][$c2x+1]
                }
                if($what -eq 'd'){
                    if($c1x-1 -eq -1){$c1x=7}
                    if($c2x-1 -eq -1){$c2x=7}
                    $c1 = $board[$c1y][$c1x-1]
                    $c2 = $board[$c2y][$c2x-1]
                }
            }elseif($c1x -eq $c2x){
                if($what -eq 'e'){
                    if($c1y+1 -eq 7){$c1y=-1}
                    if($c2y+1 -eq 7){$c2y=-1}
                    $c1 = $board[$c1y+1][$c1x]
                    $c2 = $board[$c2y+1][$c2x]
                }
                if($what -eq 'd'){
                    if($c1y-1 -eq -1){$c1y=7}
                    if($c2y-1 -eq -1){$c2y=7}
                    $c1 = $board[$c1y-1][$c1x]
                    $c2 = $board[$c2y-1][$c2x]
                }
            }elseif($c1y -eq $c2y){
                if($what -eq 'e'){
                    if($c1x+1 -eq 7){$c1x=-1}
                    if($c2x+1 -eq 7){$c2x=-1}
                    $c1 = $board[$c1y][$c1x+1]
                    $c2 = $board[$c2y][$c2x+1]
                }
                if($what -eq 'd'){
                    if($c1x-1 -eq -1){$c1x=7}
                    if($c2x-1 -eq -1){$c2x=7}
                    $c1 = $board[$c1y][$c1x-1]
                    $c2 = $board[$c2y][$c2x-1]
                }
            }else{
                $c1 = $board[$c1y][$c2x]
                $c2 = $board[$c2y][$c1x]
            }
            $cypher+=($c1+$c2)
 } 

$cypher = $cypher -replace ('♂',' ')
Set-Clipboard -Value $cypher 
write-output $cypher 
}

# This example pipes the contents of a file to the clipboard. In this example, we are getting a public ssh key so that it can be pasted into another application, like GitHub.
# qkjr9fwnnlvl ogrjl!oif?apalkdpo?wo/f/oerf9op!oif?arernwftb, gb!oijo?gvnaqoi9/3f9bof9hfoogbf f/qnmrjb?oqj!fhv?ow/qkdo,fo!dna mi ocolka!gbop/fapqkil/fqqrednrkpa? reff fkrqhu,
# this example pipes the contents of a file to the clipboard. in this example, we are getting a public ssh key so that it can be pasted into another application, like github.