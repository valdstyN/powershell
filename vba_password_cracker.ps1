# --- script to remove the password of VBA-protected code in Excel documents ---
# This script makes use of the following techniques in PS:
# - create/delete/rename folders/files
# - unzip and zip archives
# - read and write bytes

# 1. rename .xlsm to .zip
$curpath = $PSScriptRoot
$filename = Read-Host "filename"
$filepath =  $curpath+'\'+$filename
$zippath = ($filepath.Replace('xlsm','zip'))
Rename-Item -Path $filepath -NewName $zippath

# 2. extract archive
New-Item -Path ($curpath+'\'+$filename) -ItemType Directory
Expand-Archive -Path $zippath -DestinationPath ($curpath+'\'+$filename)

# 3. edit xl/vbaProject.bin
$pwnd = ($curpath+'\'+$filename+'\xl\vbaProject.bin')
$a = [System.IO.File]::ReadAllBytes($pwnd)
for($p = 0; $p -lt ($a.Length); $p++){ 
  if($a[$p] -eq 68 -and $a[$p+1] -eq 80 -and $a[$p+2] -eq 66 -and $a[$p+3] -eq 61 -and $a[$p+4] -eq 34){
    # found DBP="
    $offset = ($p+2)
    break
  }
}
#replace by DBx= (here 120 or 0x78)
$a[$offset] = 120
[System.IO.File]::WriteAllBytes($pwnd, $a)

# 4. pack archive back to zip, then rename to xlsm
$compress = @{
  Path = $curpath+'\'+$filename+'\*'
  CompressionLevel = "Fastest"
  DestinationPath = ($curpath+'\_temp_.zip')
}
Compress-Archive @compress
Remove-Item ($curpath+'\'+$filename) -Recurse
Rename-Item -Path ($curpath+'\_temp_.zip') -NewName $filepath
Remove-Item $zippath

# 5. open the XLSM document (ignore the errors), go to VBA Developer > Project properties and put a new password