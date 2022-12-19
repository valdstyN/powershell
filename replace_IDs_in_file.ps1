# Use case:
# You have a CSV file that contains IDs that need to be mapped at once (based on a mapping.csv file)

Add-Type -AssemblyName System.Windows.Forms
$browser = New-Object System.Windows.Forms.FolderBrowserDialog
$null = $browser.ShowDialog()
$path = $browser.SelectedPath

Get-ChildItem $path -Filter *.csv |
Foreach-Object {
  $content = Get-Content $_.FullName
  foreach($line in Get-Content .\mapping.csv) {
    $legacy = $line.split(",")[0]
    $destination = $line.split(",")[1]
    $content = $content -replace $legacy, $destination
  }
  $content | Set-Content ( '.\out\' + $_.BaseName + '_ID.csv')        
}
