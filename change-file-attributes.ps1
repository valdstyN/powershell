# Script opens a file and read its attributes
# Any attribute can then be edited

Add-Type -AssemblyName System.Windows.Forms
$opendlg = New-Object System.Windows.Forms.OpenFileDialog -Property @{ InitialDirectory = [Environment]::GetFolderPath('Desktop') }
$null = $opendlg.ShowDialog()

$p = "1"

while($p -ne ''){
    cls
    Get-ItemProperty -Path $opendlg.FileName | Format-list -Property * -Force
    $p = Read-Host 'Update property name'
    if($p -eq ''){exit}
    $v = Read-Host 'Change to new value'
    Set-ItemProperty -Path $opendlg.FileName -Name $p -Value $v
}
