Enable PowerShell scripts with command:<br/>
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass -Force<br/>
<br/>
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls -bor [Net.SecurityProtocolType]::Tls11 -bor [Net.SecurityProtocolType]::Tls12<br/>

