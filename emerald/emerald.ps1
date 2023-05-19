Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass -Force
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Net.Http
[System.Windows.Forms.Application]::EnableVisualStyles();
$session = new-object microsoft.powershell.commands.webrequestsession

$form = New-Object System.Windows.Forms.Form
$form.Text = "emerald3"
$form.Width = 240
$form.Height = 240
$form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
$form.FormBorderStyle = 'Fixed3D'
$form.MaximizeBox = $false
$iconBase64      = 'AAABAAEAICAYAAAAAACoDAAAFgAAACgAAAAgAAAAQAAAAAEAGAAAAAAAAAwAAAAAAAAAAAAAAAAAAAAAAAD////////////////////////+//z////+///9/6nr/z/U/gvK/gDL/wC+/QCr+ACq9QCt8gCi7wCT7gCk8ADd+gD//wD5/gD7/gD9/wD//wD
+/wD+/wD//wD//wD//wD+//7+/vv+/vv+/v3+/v7////+//3////9//7//+/k/G/J+wHW/wCg1AKQzwCz/wCr9gCs8wCi8QCU6ACn5QDe9QD9/wDy/gDz/gD5/gD+/wD9/wD+/wD+/wD//wD//wD////////////////////////9/vv////+/v7X8KPO/z
/U/wGk1wBjmAFkoQCa4QCt9wCw+QCk8gCc6gCt4wDd8wD5/gDw/gDw/QDz/wD4/wD+/wD//wD9/wD//wD//wD+//n8/uj8/un+/vv+/v7+/v77/fn///////+f2TmR3QCt3gRdlQBEfABOhgBrqgCe5gCx+gCh7ACY4ACw4gDd9AD2/wDw/gDy/gDv/gD0/
wD//wD+/gD+/wD+/gD+/gD9/+b1/Zf0/Y77/tv9/v3+/v77/Pn///////+l2nJZowZOgQBKgQBOhgBGfABSigCExwCk6wCV3ACFxQCm1gDZ8QD0/wDw/gDx/gDx/gD2/wD//wD+/gD+/wD+/gD+/gD9/+74/cHy/IT2/ab//f/9/f/8/Pf9/v34+vbn9OCW
v2JHhQBKgQBQhwJJgQBVjgCCxQCS1wCJywCDwgCFxAC44wDr/QD0/gD1/wD3/QD8/gD+/wD//wD8/gD+/gD//wD+//v9/vb5/sv3/bD4/cT///X////////////q+MOWxUhXlAFMhABGewJTjAByswCHzQCJzQCCxwCCxgCIyQC05wDd/QDk/QDk/gDt/QD
7/wD//wD9/QD//wD+/gDi7gD////+/f3////8/ubz/Jv199P+/Pz8/fzk7dqc0j9hqgBQigJMhQBQiABrqgCIzwCIzwCJzgCFzACNzwC15ADO9wDS/wDQ/gDP/gDY/gDr/gD9/wD+/QD7/ADm7wCuzwD////+/f7+/v/+/v75+vHM0Knl5NTZ59dakiNcoA
JpqgJSjwBdlgCAvQCP0wCGzACHzgCFzACO0ACu4gDY+QDZ/gDN/gDQ/gDQ/gDN/gDX/gDx/wD9/gDj8AC51gChxwD+//7+/v78/Pr///////+gspWKqoaUvpBMjB5FhgBcngB4uACezwC45ACq3wCMzgCJzgB+xgCS1gDE9wDe/wDW/gDL/gDR/gDQ/gDP/
wDa/QDq/wDm/wDO9ACw2QCexAD////8/fz8/fz4+vfW5NSHq4lmmmp3q3V0p2ZUji5UlQuKxADD6wDN7gC74QCj2QCHzgBougB/1QCy/wC4/QDS+wDc/wDL/QDP/gDa/gDi/gDg/gDY/gDP/ADA7wCt2QD////6/Pr////s8+yWvpZ+r36BsYCCsISCsINx
pWt0qCuXxAC/4wDE6QHH6AC95ACEzQBVsgBhyACG9QCQ+gC8+wDa/QDV/gDb/wDh/QDf/wDZ/wDb/gDW/wDL/gDB9gD////5+/n+/v7n8OeBsYF1qXWBsIF9rX9/r4CDsnijzDbF5wDE5wDA5QHL6gDA5QCBywBVtwBQtwBmzwCK8wCK/ACt+QDx/gDw/wD
f/QDZ/wDa/wDX/wDO/wDG/wDG/wD////9/f3////V2tVthW1ul26DtoKAsIN8qnprpjt9wRGr4wHD6ADK6AC54QCQ0ABivQBRtgBNsQBVugB33wB07QCS8gDY/gDg/gDY/gDY/gDZ/gDQ/ADE+QDB+gDK/wD////////h5OGVm5VkbGRpgWp5pHZ4nH5ugn
temhdivwCE0wKs4QC75QCa2ABkwQBKsgBMswBQtABQtgBqywBu3gCR8QDQ/gDT/gDR/QDX/wDU/QDL+QC+8wDA9QDM/gD////+/v7Lz8t4gnhfa19hbmBrf2trfW5lc2BvrBp30wB90QGK1gCS2ACL2QB0zwBXugBNtABQtQBYtgBsvgBozgCO6gDU/wDa/
wDT/gDV/wDV/gDQ+gDF9gDD9wDL/gD////7+/v4+fjIy8hcZ1xXZVRobHNpeV51tB16zwJ60QB60AB70QB4zwCQ1wCg3ABzyABQtwBTswBotgBstwBotAB5zwCm/ADR/wDZ/gDT/gDZ/wDX/wDP/gDK/gDL/gD////8/Pz////7+/vDyMJ9hXxLZE9PiS12
zACA2gB6zwB70AB+1QB81ABcowBKggBtswBuwgBktgBqtABqtABqsQBpuAB50QCp5wDR+gDI+wCl8gCq+AC//ADK/QDM/wD////+/v77+/v////////Jy8h4p3dRrzRUrQBuwQB/0wB81QBxxgBbpwAgYwABQAA5dwBeogBosQBrtwBptQBstwBosgBrsgC
I1QCu8QCo8wCC6ACC6gCg8AC89wDJ/QD////////+//79/f37/Pz///7e/+GR3Y5UrDFcpwN6xAB3zQBWogAdXQAJRAAUUQAMSAAgYQBLkwBqtwBstwBqtQBlrgBpswCG3gCO7gCJ6gCN6wCF5gCL5QCm7QDE+gD////////+//79/f39/f3////+//7j/e
ep8KpqqSdbkwBmpgJRiwAbVwAGQwAUUAARTgAKRQAlaABXpwBtuQBkrwBRnQBbqQCH5ACR8wCI5wCM6wCN7ACB3wCQ3gC89AD////+/v7//v/+/v7+/v75+vf//P/x9uuNwlxelBdYiARbjwFYigNJfgIpZQEPTAEOSQAYUwAwdQBLmwBXpABSnwBIlABNn
ABtxQCH5QCQ7gCO7ACM6gB30wBuxAB/zgD////////+//7////////5+vb9//7l7NhpkRJLgABajQFbjQFUiQBckAA6cAANSQAcXwA9gwBNlgBJlgBFlABHlQBHlQBIlgBaqAB70ACQ7QCI5wB61gBnwgBeuABiuwD////////////+/v7+/v77/Pr+/v7z
9u2nw3lplxhUiABYiwBZjQNllRFEbw4dTQA3ewBTnwBXoABNlgBKlwBJmABHlgBOmgBnrgCAxwCI2gB82ABmwABfuQBpvQB2uQD////////////+/v7+/v7+/v79/fz9/vzz9+280JdnlhZRhgCRslm60HySpFJJXSAvVAVKggFinwFYlgBPlwBImABKlgF
dngB6uwCGxwCBxQB2xABetwBovABysQBgiwD////////////////////////9/fz////////09+7D1aGxyYjc5sz2+d/k5sWfooxGTjVJcgFmogBdlQFZlwJVmAFTkwBfmQB/vgCHyAB/vAB+vgB+zwCLywB4pABHegD////////////////////+/v7+/v
7+/v77/Pr////////////////////////o5+yVlJJefjBWkAVelgBblQBckwBgmABrpwCCwQCHxwCGxgCGyQB3uQBzqABglAA7fwD////////////////////////////////////+/v7+/v3+/v3+/v78/Pz+/v3+/v7q6OqJnoxZhztwpx5gmQFimRR+t
DCSzCiFxQWAvwCH1AB40QA7cAcqXgQ6gAA2eQD////////////////////////////////////+/v7+/v7+/v7+/v7+/v39/f3////////H4cui0J+j0YeDtkmOwGe44q645JpvsRhirwBt1AFPxAAwXB4rSBo0cAIwcgD////////////////////////+
/v7////+///+/v7+/v7+/v7+/v7////9/f3+/v7+/v7y//DT9tW15LWn1ZbP9Mu34sBanUlDnAZQwwBQwgA6hRQySy9HWyVikQlppgD////////////////////////////////////////////////////+/v7+/v7+/v79/f3+/P7o9OfJ68jE68ay3bC
KuH1enUBGrAxCtABBiRU5TC8yPTRVbSSJtA2n4AD////////////////////////////////////////////////////////////+/v7+/v7////7/fvv+u/W9dlioFF5o2jp+d5vyzUygwE/WDE3RjIzQDRRaiWHsg2t5gAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=='
$iconBytes       = [Convert]::FromBase64String($iconBase64)
$stream          = [System.IO.MemoryStream]::new($iconBytes, 0, $iconBytes.Length)
$form.Icon       = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($stream).GetHIcon()))
# -------------------------------------------------------------------------------------------------------
$button1 = New-Object System.Windows.Forms.Button
$button1.Text = "Remove VBA password (XLSM)"
$button1.Width = 200
$button1.Location = New-Object System.Drawing.Point(10, 10)
$form.Controls.Add($button1)
$button1.Add_Click({
    $opendlg = New-Object System.Windows.Forms.OpenFileDialog -Property @{ InitialDirectory = [Environment]::GetFolderPath('Desktop') }
    $null = $opendlg.ShowDialog()

    if($opendlg.FileName -ne ''){
        # 1. rename .xlsm to .zip
        $curpath = ($opendlg.FileName -replace ("\\"+$opendlg.SafeFileName), '')
        $filename = $opendlg.SafeFileName
        $filepath =  $opendlg.FileName
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
        [System.Windows.MessageBox]::Show("VBA protection removed.")

    }
})
# -------------------------------------------------------------------------------------------------------
$button2 = New-Object System.Windows.Forms.Button
$button2.Text = "Remove Sheet protection (XLSX)"
$button2.Width = 200
$button2.Location = New-Object System.Drawing.Point(10, 35)
$form.Controls.Add($button2)
$button2.Add_Click({
    $opendlg = New-Object System.Windows.Forms.OpenFileDialog -Property @{ InitialDirectory = [Environment]::GetFolderPath('Desktop') }
    $null = $opendlg.ShowDialog()

    if($opendlg.FileName -ne ''){
        [void][Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')
        $sheet = ("sheet"+[Microsoft.VisualBasic.Interaction]::InputBox('', 'Sheet index?'))

        # 1. rename .xlsm to .zip
        $curpath = ($opendlg.FileName -replace ("\\"+$opendlg.SafeFileName), '')
        $filename = $opendlg.SafeFileName
        $filepath =  $opendlg.FileName
        $zippath = ($filepath.Replace('xlsx','zip')) # should also work for XLSM
        Rename-Item -Path $filepath -NewName $zippath

        # 2. extract archive
        New-Item -Path ($curpath+'\'+$filename) -ItemType Directory
        Expand-Archive -Path $zippath -DestinationPath ($curpath+'\'+$filename)

        # 3. edit xl/sheet.xml
        $pwnd = ($curpath+'\'+$filename+'\xl\worksheets\'+$sheet+".xml")
        $content = [System.IO.File]::ReadAllText($pwnd) -replace "<sheetProtection.+/>",""
        [System.IO.File]::WriteAllText($pwnd, $content)

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

        [System.Windows.MessageBox]::Show("Worksheet protection removed.")
      }
})
# -------------------------------------------------------------------------------------------------------
# next : get all wifis and output pwd in listbox
$button3 = New-Object System.Windows.Forms.Button
$button3.Text = "Display saved WIFI passwords"
$button3.Width = 200
$button3.Location = New-Object System.Drawing.Point(10, 60)
$form.Controls.Add($button3)
$button3.Add_Click({
    $ssid.Clear()
    $ssid.Columns.Add("SSID", 150) | Out-Null
    $ssid.Columns.Add("Password", 150) | Out-Null
    $e = netsh wlan show profile
    for($i = 2;$i -lt $e.Count;$i++){
                if($e[$i].indexOf(':') -ne -1){
                        # is a wifi
                        $ssidname = $e[$i].substring($e[$i].indexOf(': ')+2)
                        $pwd = netsh wlan show profile name="$ssidname" key=clear
                $pwd = ($pwd -join '~~')
                $j =  $pwd.indexOf('Key Content')
                if($j -ne -1){
                    $pwd = $pwd.Substring($j)
                    #$pwd -match ":\s(.*?)~~"
                    #$pwd = $Matches[1]
                    $k = [regex]::Match($pwd,":\s(.*?)~~")
                    $pwd = $k.Groups.Item(1).value
                }else{
                    $pwd = '(none saved)'
                }
                $ssid_row = New-Object System.Windows.Forms.ListViewItem($ssidname)
                $ssid_row.SubItems.Add($pwd)
                $ssid.Items.Add($ssid_row)
                }
     }
    $form3.ShowDialog() | Out-Null
})
    $form3 = New-Object System.Windows.Forms.Form
    $form3.Text = "Display saved WIFI passwords"
    $form3.Width = 370
    $form3.Height = 300
    $form3.Icon       = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($stream).GetHIcon()))
    $ssid = New-Object System.Windows.Forms.ListView
    $ssid.Width = 330
    $ssid.Height = 240
    $ssid.Location = New-Object System.Drawing.Point(10, 12)
    $ssid.View = [System.Windows.Forms.View]::Details
    $ssid.FullRowSelect = $true
    $ssid.Columns.Add("SSID", 150) | Out-Null
    $ssid.Columns.Add("Password", 150) | Out-Null
    $form3.Controls.Add($ssid)
    $ssid.add_DoubleClick({
        Set-Clipboard -Value ($ssid.SelectedItems[0].SubItems[1].text)
    })
# -------------------------------------------------------------------------------------------------------
$button4 = New-Object System.Windows.Forms.Button
$button4.Text = "Send HTTP query"
$button4.Width = 200
$button4.Location = New-Object System.Drawing.Point(10, 85)
$form.Controls.Add($button4)
$button4.Add_Click({
    $formHTTP.ShowDialog() | Out-Null
})
    $formHTTP = New-Object System.Windows.Forms.Form
    $formHTTP.Text = "Send HTTP query"
    $formHTTP.Width = 640
    $formHTTP.Height = 550
    $formHTTP.Icon = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($stream).GetHIcon()))
    $httpMethod = New-Object System.Windows.Forms.TextBox
    $httpMethod.Text = "GET"
    $httpMethod.Width = 70
    $httpMethod.Location = New-Object System.Drawing.Point(10, 12)
    $httpURL = New-Object System.Windows.Forms.TextBox
    $httpURL.Text = "https://google.com"
    $httpURL.Width = 460
    $httpURL.Location = New-Object System.Drawing.Point(90, 12)
    $httpSEND = New-Object System.Windows.Forms.Button
    $httpSEND.Text = "Send"
    $httpSEND.Width = 50
    $httpSEND.Location = New-Object System.Drawing.Point(560, 10)
    $httpTAB = New-Object System.Windows.Forms.TabControl
    $httpTAB.Width = 600
    $httpTAB.Height = 450
    $httpTAB.Location = New-Object System.Drawing.Point(10, 45)
    $formHTTP.Controls.Add($httpTAB)

    $Tab1 = New-object System.Windows.Forms.Tabpage
    $Tab1.DataBindings.DefaultDataSourceUpdateMode = 0
    $Tab1.UseVisualStyleBackColor = $True
    $Tab1.Name = "Tab1"
    $Tab1.Text = "QUERY"
    $httpTAB.Controls.Add($Tab1)

    # tab input

    $httpHeaderIn = New-Object System.Windows.Forms.TextBox
    $httpHeaderIn.Text = "Authorization:Basic xxx; Content-Type: Application/json"
    $httpHeaderIn.Width = 570
    $httpHeaderIn.Height = 80
    $httpHeaderIn.Multiline = $true
    $httpHeaderIn.Location = New-Object System.Drawing.Point(10, 12)

    $Tab1.Controls.Add($httpHeaderIn)

    $httpBodyIn = New-Object System.Windows.Forms.TextBox
    $httpBodyIn.Text = ""
    $httpBodyIn.Width = 570
    $httpBodyIn.Height = 300
    $httpBodyIn.Multiline = $true
    $httpBodyIn.ScrollBars = "Vertical"
    $httpBodyIn.Location = New-Object System.Drawing.Point(10, 120)

    $Tab1.Controls.Add($httpBodyIn)

    $httpBodyEna = New-Object System.Windows.Forms.CheckBox
    $httpBodyEna.Text = "Send body"
    $httpBodyEna.Location = New-Object System.Drawing.Point(10, 95)

    $Tab1.Controls.Add($httpBodyEna)

    $Tab2 = New-object System.Windows.Forms.Tabpage
    $Tab2.DataBindings.DefaultDataSourceUpdateMode = 0
    $Tab2.UseVisualStyleBackColor = $True
    $Tab2.Name = "Tab2"
    $Tab2.Text = "RESPONSE"
    $httpTAB.Controls.Add($Tab2)

    # tab output
    $httpHeaderOut = New-Object System.Windows.Forms.ListView
    $httpHeaderOut.Text = ""
    $httpHeaderOut.Width = 570
    $httpHeaderOut.Height = 80
    $httpHeaderOut.View = [System.Windows.Forms.View]::Details
    $httpHeaderOut.FullRowSelect = $true
    $httpHeaderOut.Columns.Add("Header", 200) | Out-Null
    $httpHeaderOut.Columns.Add("Value", 280) | Out-Null
    $httpHeaderOut.Location = New-Object System.Drawing.Point(10, 12)

    $Tab2.Controls.Add($httpHeaderOut)

    $httpBodyOut = New-Object System.Windows.Forms.TextBox
    $httpBodyOut.Text = ""
    $httpBodyOut.Width = 570
    $httpBodyOut.Height = 300
    $httpBodyOut.Multiline = $true
    $httpbodyout.ReadOnly = $true
    $httpBodyOut.ScrollBars = "Vertical"
    $httpBodyOut.Location = New-Object System.Drawing.Point(10, 107)

    $Tab2.Controls.Add($httpBodyOut)

    $formHTTP.Controls.Add($httpMethod)
    $formHTTP.Controls.Add($httpSEND)
    $formHTTP.Controls.Add($httpURL)
    $httpSEND.add_Click({
        $Tab2.Text = ("RESPONSE")
        $httpHeaderOut.Clear()
        $httpHeaderOut.Columns.Add("Header", 200) | Out-Null
        $httpHeaderOut.Columns.Add("Value", 280) | Out-Null
        # send request
        $meth = $httpMethod.Text
        $uri = $httpURL.Text
        $inh = ($httpHeaderIn.Text).Split(';')
        $inb = $httpBodyIn.Text
        $headers = @{}
        if($httpHeaderIn.Text.IndexOf(';') -ne -1){
            for($i;$i -le $inh.Count; $i++){
                $headers[$inh.Split(':')[0].Trim()] = $inh.Split(':')[1].Trim()
            }
        }
        if($httpBodyEna.Checked -eq $true){
            $r = Invoke-WebRequest -Method $meth -Uri $uri -Body $inb -Headers $headers -WebSession $session
        }else{
            $r = Invoke-WebRequest -Method $meth -Uri $uri -Headers $headers -WebSession $session
        }
        $Tab2.Text = ("RESPONSE ("+$r.StatusCode+")")
        # display headers
        foreach($v in $r.Headers.GetEnumerator()){
            $listItem = New-Object System.Windows.Forms.ListViewItem($v.Key)
            $listItem.SubItems.Add($v.Value)
            $httpHeaderOut.Items.Add($listItem)
        }
        # display body
        $httpBodyOut.Text = $r
        $httpTAB.SelectedTab = $httpTAB.TabPages['Tab2']
    })
    $httpHeaderOut.add_DoubleClick({
        Set-Clipboard -Value ($httpHeaderOut.SelectedItems[0].Text + "=" + $httpHeaderOut.SelectedItems[0].SubItems[1].text)
    })
    $httpBodyOut.add_DoubleClick({
        Set-Clipboard -Value ($httpBodyOut.Text)
    })

# -------------------------------------------------------------------------------------------------------
$button5 = New-Object System.Windows.Forms.Button
$button5.Text = "Change file attributes"
$button5.Width = 200
$button5.Location = New-Object System.Drawing.Point(10, 110)
$form.Controls.Add($button5)
$button5.Add_Click({
    $form2.ShowDialog() | Out-Null
})
    $global:attfile = ""
    $form2 = New-Object System.Windows.Forms.Form
    $form2.Text = "Change file attributes"
    $form2.Width = 490
    $form2.Height = 250
    $form2.Icon = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($stream).GetHIcon()))
    $openfile = New-Object System.Windows.Forms.Button
    $openfile.Text = "Select file..."
    $openfile.Width = 200
    $openfile.Location = New-Object System.Drawing.Point(10, 10)
    $form2.Controls.Add($openfile)
    $openfile.Add_Click({
        $opendlg = New-Object System.Windows.Forms.OpenFileDialog -Property @{ InitialDirectory = [Environment]::GetFolderPath('Desktop') }
        $null = $opendlg.ShowDialog()
        $t = Get-ItemProperty -Path $opendlg.FileName | Get-Member * -Force
        $global:attfile = $opendlg.FileName
        $listBox.Clear()
        $listBox.Columns.Add("Attribute", 150) | Out-Null
        $listBox.Columns.Add("Value", 260) | Out-Null

        foreach($i in $t){
            if ($i.MemberType -eq "Property" -and $i.Name -notlike "__*") {
                $listItem = New-Object System.Windows.Forms.ListViewItem($i.Name)
                $listItem.SubItems.Add((Get-ChildItem $opendlg.FileName).$($i.Name).toString())
                $listBox.Items.Add($listItem)
            }
        }
    })
    $listBox = New-Object System.Windows.Forms.ListView
    $listBox.Location = New-Object System.Drawing.Point(10, 45)
    $listBox.Size = New-Object System.Drawing.Size(450, 150)
    $listBox.View = [System.Windows.Forms.View]::Details
    $listBox.FullRowSelect = $true
    $listBox.Columns.Add("Attribute", 150) | Out-Null
    $listBox.Columns.Add("Value", 260) | Out-Null
    $form2.Controls.Add($listBox)
    $listBox.Add_DoubleClick({
        [void][Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')
        $newval = [Microsoft.VisualBasic.Interaction]::InputBox('', 'New value?')

        Set-ItemProperty -Path $global:attfile -Name ($listBox.SelectedItems[0].Text) -Value $newval
        # clear and refresh to confirm it's been saved
        $t = Get-ItemProperty -Path $global:attfile | Get-Member * -Force

        $listBox.Clear()
        $listBox.Columns.Add("Attribute", 150) | Out-Null
        $listBox.Columns.Add("Value", 260) | Out-Null

        foreach($i in $t){
            if ($i.MemberType -eq "Property" -and $i.Name -notlike "__*") {
                $listItem = New-Object System.Windows.Forms.ListViewItem($i.Name)
                $listItem.SubItems.Add((Get-ChildItem $global:attfile).$($i.Name).toString())
                $listBox.Items.Add($listItem)
            }
        }
    })

# -------------------------------------------------------------------------------------------------------
# b64 encoder/decoder
$buttonB64 = New-Object System.Windows.Forms.Button
$buttonB64.Text = "Base64 encoder/decoder"
$buttonB64.Width = 200
$buttonB64.Location = New-Object System.Drawing.Point(10, 135)
$form.Controls.Add($buttonB64)
$buttonB64.Add_Click({
    $formB64.ShowDialog() | Out-Null
})
    $formB64 = New-Object System.Windows.Forms.Form
    $formB64.Text = "Base64 encoder/decoder"
    $formB64.Width = 500
    $formB64.Height = 350
    $formB64.Icon = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($stream).GetHIcon()))
    $b64src = New-Object System.Windows.Forms.TextBox
    $b64src.Text = ""
    $b64src.Width = 460
    $b64src.Height = 260
    $b64src.Multiline = $true
    $b64src.Location = New-Object System.Drawing.Point(10, 12)
    $b64ENC = New-Object System.Windows.Forms.Button
    $b64ENC.Text = "Encode to B64"
    $b64ENC.Width = 100
    $b64ENC.Location = New-Object System.Drawing.Point(10, 280)
    $b64DEC = New-Object System.Windows.Forms.Button
    $b64DEC.Text = "Decode from B64"
    $b64DEC.Width = 100
    $b64DEC.Location = New-Object System.Drawing.Point(115, 280)
    $formB64.Controls.Add($b64src)
    $formB64.Controls.Add($b64ENC)
    $formB64.Controls.Add($b64DEC)
    $b64ENC.Add_Click({
        $src = $b64src.Text
        $Bytes = [System.Text.Encoding]::UTF8.GetBytes($src)
        $prc = [Convert]::ToBase64String($Bytes)
        $b64src.Text = $prc
    })
    $b64DEC.Add_Click({
        $src = $b64src.Text
        $prc = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($src))
        $b64src.Text = $prc
    })
# ------------ ADS --------------------
$buttonADS = New-Object System.Windows.Forms.Button
$buttonADS.Text = "Read/Write Alternate Data Streams"
$buttonADS.Width = 200
$buttonADS.Location = New-Object System.Drawing.Point(10, 160)
$form.Controls.Add($buttonADS)
$buttonADS.Add_Click({
	$formADS.ShowDialog() | Out-Null
})
    $formADS = New-Object System.Windows.Forms.Form
    $formADS.Text = "Read/Write Alternate Data Streams"
    $formADS.Width = 370
    $formADS.Height = 250
    $formADS.Icon = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($stream).GetHIcon()))
    $adsLoad = New-Object System.Windows.Forms.Button
    $adsLoad.Text = "Select file..."
    $adsLoad.Width = 100
    $adsLoad.Location = New-Object System.Drawing.Point(10, 10)
    $adsAdd = New-Object System.Windows.Forms.Button
    $adsAdd.Text = "Add ADS..."
    $adsAdd.Width = 80
    $adsAdd.Location = New-Object System.Drawing.Point(115, 10)
    $listADS = New-Object System.Windows.Forms.ListView
    $listADS.Width = 330
    $listADS.Height = 150
    $listADS.Location = New-Object System.Drawing.Point(10, 45)
    $listADS.View = [System.Windows.Forms.View]::Details
    $listADS.FullRowSelect = $true
    $listADS.Columns.Add("Stream", 200) | Out-Null
    $listADS.Columns.Add("Length", 100) | Out-Null
    $adsOpenWithLabel = New-Object System.Windows.Forms.Label
    $adsOpenWithLabel.Text = "Open with"
    $adsOpenWithLabel.Width = 80
    $adsOpenWithLabel.Location = New-Object System.Drawing.Point(200, 15)
    $adsOpenWith = New-Object System.Windows.Forms.TextBox
    $adsOpenWith.Text = "notepad.exe"
    $adsOpenWith.Width = 80
    $adsOpenWith.Location = New-Object System.Drawing.Point(260, 12)
    $formADS.Controls.Add($adsLoad)
    $formADS.Controls.Add($adsAdd)
    $formADS.Controls.Add($listADS)
    $formADS.Controls.Add($adsOpenWith)
    $formADS.Controls.Add($adsOpenWithLabel)
    $form2.Controls.Add($openfile)
    $adsLoad.Add_Click({
        $opendlg = New-Object System.Windows.Forms.OpenFileDialog -Property @{ InitialDirectory = [Environment]::GetFolderPath('Desktop') }
        $null = $opendlg.ShowDialog()
        $t = Get-Item $opendlg.FileName -stream *
        $global:adsfile = $opendlg.FileName
        $listADS.Clear()
   	    $listADS.Columns.Add("Stream", 200) | Out-Null
    	$listADS.Columns.Add("Length", 100) | Out-Null
        $ads = Get-Item $global:adsfile -stream *
        $formADS.Text = $opendlg.SafeFileName
        for($a = 0; $a -lt $ads.Count; $a++){
            $adsItem = New-Object System.Windows.Forms.ListViewItem($ads[$a].Stream)
            $adsItem.SubItems.Add($ads[$a].Length)
            $listADS.Items.Add($adsItem)
        }       
    })
    $adsAdd.Add_Click({
        $opendlg = New-Object System.Windows.Forms.OpenFileDialog -Property @{ InitialDirectory = [Environment]::GetFolderPath('Desktop') }
        $null = $opendlg.ShowDialog()
        $t = Get-ItemProperty -Path $opendlg.FileName | Get-Member * -Force
        $global:adssecret = $opendlg.FileName
        # add the ADS
        Set-Content -path $global:adsfile -value $(get-content $global:adssecret -readcount 0 -encoding byte) -encoding byte -stream $opendlg.SafeFileName
        $listADS.Clear()
   	    $listADS.Columns.Add("Stream", 200) | Out-Null
    	$listADS.Columns.Add("Length", 100) | Out-Null
        # reload the list
        $ads = Get-Item $global:adsfile -stream *
        for($a = 0; $a -lt $ads.Count; $a++){
            $adsItem = New-Object System.Windows.Forms.ListViewItem($ads[$a].Stream)
            $adsItem.SubItems.Add($ads[$a].Length)
            $listADS.Items.Add($adsItem)
        }
    })
    $listADS.add_DoubleClick({
        Invoke-Expression($adsOpenWith.text+' '+($global:adsfile+":"+$listADS.SelectedItems[0].Text))
    })
    $listADS.Add_KeyDown({if ($PSItem.KeyCode -eq "Delete") 
        {
            Remove-Item $global:adsfile -stream $listADS.SelectedItems[0].Text
            $listADS.Clear()
   	        $listADS.Columns.Add("Stream", 200) | Out-Null
    	    $listADS.Columns.Add("Length", 100) | Out-Null
            $ads = Get-Item $global:adsfile -stream *
            for($a = 0; $a -lt $ads.Count; $a++){
                $adsItem = New-Object System.Windows.Forms.ListViewItem($ads[$a].Stream)
                $adsItem.SubItems.Add($ads[$a].Length)
                $listADS.Items.Add($adsItem)
            }
        }
    })
# -------------------------------------------------------------------------------------------------------
$form.ShowDialog() | Out-Null
