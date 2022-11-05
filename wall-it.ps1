<#
The first time the script is executed (and everytime you change the wallpaper), type in ".get" as command to create a copy of the wallpaper.
This copy will be used everytime you then want to write a message.

Once the new wallpaper has been saved ("wallpaper.bmp" in the local folder), it will be set automatically.

Font: Arial, 20
Position of the text is based on the mouse coordinates.

#>

# had to put these 2 lines else the script wouldn't work in console 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

# something like...https://learn.microsoft.com/en-us/sysinternals/downloads/bginfo

$thispath = $PSScriptRoot + "\"
$backupExist = Test-Path -Path ($thispath + "TranscodedWallpaper") -PathType Leaf

# edit message
$text = Read-Host "Write message?"

if($text -eq ".get" -or $backupExist -eq 0){
    # save the wallpaper to script folder
    Copy-Item ("C:\Users\"+[System.Windows.Forms.SystemInformation]::UserName+"\AppData\Roaming\Microsoft\Windows\Themes\TranscodedWallpaper") -Destination ($thispath + "TranscodedWallpaper")
}
if($text -eq ".get"){
    # gives the possibility to write without having to relaunch
    $text = Read-Host "Write message?"
}

# get the current wallpaper as BMP -- ok but if we set as wallpaper, it won't be "blank" anymore
$bmp = [System.Drawing.Bitmap]::FromFile($thispath + "TranscodedWallpaper")

# edit BMP
$g = [System.Drawing.Graphics]::FromImage($bmp)
$font = [System.Drawing.Font]::new("Arial",20)
$brush = [System.Drawing.Brushes]::White
$bw = $bmp.Width
$bh = $bmp.Height
$pX  = [Math]::abs([System.Windows.Forms.Cursor]::Position.X)
$pY = [Math]::abs([System.Windows.Forms.Cursor]::Position.Y)
$g.DrawString($text, $font, $brush, $pX, $pY); 
 
# save BMP
$wpath = $thispath + "wallpaper.bmp"
$bmp.Save($wpath)

# set as wallpaper
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class Params
{
    [DllImport("User32.dll",CharSet=CharSet.Unicode)]
    public static extern int SystemParametersInfo (Int32 uAction,Int32 uParam,String lpvParam,Int32 fuWinIni);
}
"@
$SPI_SETDESKWALLPAPER = 0x0014
$UpdateIniFile = 0x01
$SendChangeEvent = 0x02
$fWinIni = $UpdateIniFile -bor $SendChangeEvent
$ret = [Params]::SystemParametersInfo($SPI_SETDESKWALLPAPER,0,$wpath,$fWinIni)
