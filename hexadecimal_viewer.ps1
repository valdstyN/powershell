# This script generates a hexadecimal view of a binary file.
# Beware that it is pretty slow.

cls
$path = $PSScriptRoot

function set2($e){
    $n = "000"+$e
    $nlt = ($n.Length) - 1 
    $nlf = ($n.Length) - 2
    $e = -join $n[$nlf..$nlt] 
    return $e
}

function set8($e){
    $n = "0000000"+$e
    $nlt = ($n.Length) - 1 
    $nlf = ($n.Length) - 8
    $e = -join $n[$nlf..$nlt] 
    return $e
}

function getChar($i){
    if($i -eq 10 -or $i -eq 13 -or $i -eq 133){
        $c = '.'
    }else{
        $c = [char]$i
    }
    return $c
}

#$filename = 'C:\Users\valdstyN\Desktop\Useful apps\dns.bat'
#filename = 'C:\Users\valdstyN\Desktop\Useful apps\putty\PUTTYGEN.EXE'
$filename = Read-Host "Filename"
$filename = -join($path,'\',$filename)

$a = [System.IO.File]::ReadAllBytes($filename)

$line = ''
$offset = 0
$c = 0
$clearLine = ''

$full = ''

$hdr = "OFFSET`t`t00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F`t`tTEXT CONTENT"
# UNCOMMENT TO WRITE HEADER IN CONSOLE
# write-output ''
# write-output $hdr
# write-output ''

$progress = 0

$full = -join("`n",$hdr,"`n")

for($p = 0; $p -le ($a.Length); $p++){ 
    $line = -join ($line, (set2('{0:X}' -f $a[$p]))," ")
    $clearLine = -join ($clearLine,(getChar $a[$p]))
    if($c -eq 15 -or $p -eq ($a.Length-1)){
        $f = -join ((set8('{0:X}' -f $offset)),"`t",$line,"`t",$clearLine)
        # UNCOMMENT TO WRITE IN REAL TIME IN CONSOLE
        # write-output $f
        # START-SHOW PROGRESS EVERY 1%
        if($progress -ne ([math]::Round((100/$a.Length)*$p))){
            cls
            write-output $progress"% completed"
            $progress =  ([math]::Round((100/$a.Length)*$p))
        }
        # END-SHOW PROGRESS

        $full = -join ($full,"`n",$f)
        $c = 0
        $line = ''
        $clearLine = ''
        $offset += 16
    }else{
        $c++
    }
}

cls
write-output "100% completed"
$full = $full > (-join ($path,'\dump.txt'))
write-output "dump.txt file written"

# todo: check length of last line