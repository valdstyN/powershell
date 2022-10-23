<h2>If running in non-admin session, enable PowerShell scripts with command:</h2>
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass -Force<br/>
<h2>Enable TLS 1.2</h2>
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls -bor [Net.SecurityProtocolType]::Tls11 -bor [Net.SecurityProtocolType]::Tls12<br/>

