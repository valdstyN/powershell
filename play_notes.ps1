# based off https://learn.microsoft.com/en-us/dotnet/api/system.console.beep?view=net-6.0

$duration = @{ 
    "WHOLE"     = 1600;
    "HALF"      = 800;
    "QUARTER"   = 400;
    "EIGHTH"    = 200;
    "SIXTEENTH" = 100
}

$note = @{
    "REST"   = 0;
    "GbelowC" = 196;
    "A"      = 220;
    "Asharp" = 233;
    "B"      = 247;
    "C"      = 262;
    "Csharp" = 277;
    "D"      = 294;
    "Dsharp" = 311;
    "E"      = 330;
    "F"      = 349;
    "Fsharp" = 370;
    "G"      = 392;
    "Gsharp" = 415
}


function playNote($n,$d){
    if($n -eq 'REST'){
        Start-Sleep -Milliseconds $d
    }else{
       [console]::beep($note[$n],$d) 
    }
}

$song = @(
     "G;"+$duration["QUARTER"]
     "B;"+$duration["QUARTER"]
     "E;"+$duration["QUARTER"]
     "G;"+$duration["QUARTER"]
     "E;"+$duration["QUARTER"]
     "B;"+$duration["QUARTER"]
     "B;"+$duration["HALF"]
     "A;"+$duration["QUARTER"]
     "A;"+$duration["QUARTER"]
     "A;"+$duration["HALF"]
     "B;"+$duration["QUARTER"]
     "D;"+$duration["QUARTER"]
     "D;"+$duration["QUARTER"]
)


foreach($z in $song){
    $not = $z.Split(";")[0]
    $dur = $z.Split(";")[1]
    playNote $not $dur
}