<#
this version now works with shorthands (-e,-m,-f,-s,-t...)
f - filter -o out
s - select -e entity
t - top -m method
also adds -noconsole 1
Examples:
hana -m 'get' -e 'ProjectSet' -s 'ProjectID,OrgID,CreatedOn' -t 10
hana -e 'ProjectSet' -s 'ProjectID,OrgID,CreatedOn' -t 10
hana -m 'get' -e 'ProjectSet' -s 'ProjectID,OrgID' -t 10 -f "Project ID eq '00000035'"
hana -e 'A_Customer' -s 'Customer,CustomerFullName' -t 10
hana -e 'A_Customer' -cnt true
hana -e 'A_Product' -t 10 -s 'ProductType,Product'
hana -e 'ProjectSet' -t 10 -f "startswith(Project ID, 'D60')" -cnt true
hana -e 'ProjectSet' -t 100 -noconsole 1
hana -e 'ProjectSet' -t 100 -noconsole 1

Update:
hana -m 'patch' -e "A_Customer('1000000')" -b '{"d":{"TrainStationName":"Test"}}'

Mass update:
upload -m patch
upload -m post

Notes:
* method 'get' by default
* output 'csv' by default
* with parameter cnt = true (count), select and top parameters will be removed
* for mass update (upload), the file should have the following format:

  entity;key;SearchTerm1;SearchTerm2
  A_BusinessPartner;1000000;Test;Test2
  A_BusinessPartner;1000001;Test3;Test4

  The key should not have single quotes if it is a simple value. If it is a composite key, put the whole key, eg:  Customer='1000',Company='DE01'
  If there is no key needed, leave the field blank.
#>

Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass -Force
Add-Type -AssemblyName System.Windows.Forms
$opendlg = New-Object System.Windows.Forms.OpenFileDialog -Property @{ InitialDirectory = [Environment]::GetFolderPath('Desktop') }
$session = new-object microsoft.powershell.commands.webrequestsession

$apiModule = @{
    "CustomerProjects" = "cpd/SC_PROJ_ENGMT_CREATE_UPD_SRV/"
    "BusinessPartners" = "sap/API_BUSINESS_PARTNER/"
    "InternalProjects" = "sap/API_ENTERPRISE_PROJECT_SRV;v=0002/"
    "Products" = "sap/API_PRODUCT_SRV/"
}

$CPModule = "A_CustProjSlsOrd,A_CustProjSlsOrdItem,A_CustProjSlsOrdItemPartner,A_CustProjSlsOrdItemText,A_CustProjSlsOrdItemWorkPckg,A_CustProjSlsOrdItmBillgPlnItm,A_CustProjSlsOrdPartner,A_CustProjSlsOrdText,A_EngmntProjRsceDmnd,A_EngmntProjRsceDmndDistr,A_EngmntProjRsceDmndSkill,A_EngmntProjRsceSup,A_EngmntProjRsceSupDistr,WorkPackageFunctionSet,ProjectSet,WorkPackageSet,WorkItemSet,DemandSet,ProjectRoleSet"

# -- S/4 TENANT ---
$user = 'API_USER'
$pwd = 'API_PWD'
$baseUrl = 'https://myXXXXXX.s4hana.ondemand.com/sap/opu/odata/'

$creds = $user+":"+$pwd
$encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($creds))
$basicauth_header = "Basic $encodedCreds"

# the code for this format-json function is not from me; it was taken from the interwebz
function Format-Json {
    [CmdletBinding(DefaultParameterSetName = 'Prettify')]
    Param(
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]$Json,
        [Parameter(ParameterSetName = 'Minify')]
        [switch]$Minify,
        [Parameter(ParameterSetName = 'Prettify')]
        [ValidateRange(1, 1024)]
        [int]$Indentation = 4,
         [Parameter(ParameterSetName = 'Prettify')]
        [switch]$AsArray
    )
    if ($PSCmdlet.ParameterSetName -eq 'Minify') {
        return ($Json | ConvertFrom-Json) | ConvertTo-Json -Depth 100 -Compress
    }
    if ($Json -notmatch '\r?\n') {
        $Json = ($Json | ConvertFrom-Json) | ConvertTo-Json -Depth 100
    }
    $indent = 0
    $regexUnlessQuoted = '(?=([^"]*"[^"]*")*[^"]*$)'
    $result = $Json -split '\r?\n' |
        ForEach-Object {
            if ($_ -match "[}\]]$regexUnlessQuoted") {
                $indent = [Math]::Max($indent - $Indentation, 0)
            }
            $line = (' ' * $indent) + ($_.TrimStart() -replace ":\s+$regexUnlessQuoted", ': ')
            if ($_ -match "[\{\[]$regexUnlessQuoted") {
                $indent += $Indentation
            }
            $line
       }
    if ($AsArray) { return $result }
    return $result -Join [Environment]::NewLine
}


function hana($m,$e,$s,$f,$t,$b,$o,$cnt,$noconsole){

# [1] get the CSRF token
    $uri = $baseUrl + 'cpd/SC_PROJ_ENGMT_CREATE_UPD_SRV/ProjectSet?$top=1'
    $headers = @{
        'Authorization' = $basicauth_header
        'X-CSRF-Token' = 'Fetch'
        'Content-Type' = 'application/json'   
    }
    $r = Invoke-WebRequest -Method Get -Uri $uri -Headers $headers -WebSession $session
    $token = $r.Headers['X-CSRF-Token']

    # [2] set the token in the new request
    $headers = @{
        'Authorization' = $basicauth_header
        'X-CSRF-Token' = $token
        'Content-Type' = 'application/json'   
        'Accept' = 'application/json' 
        'DataServiceVersion' = '2.0'
         # extra header would be required for internal projects
    }


    # if /$count, cannot have top/select
    if($cnt -eq $true){
        $countf='/$count'
        $t=''
        $s=''
    }else{
        $countf=''
    }

    if($m.Length -eq 0){$m='get'}
    if($s.Length -ne 0){$s='$select='+$s}else{$s=""}
    if($f.Length -ne 0){$f='$filter='+$f}else{$f=""}
    if($t.Length -ne 0){$t='$top='+$t}else{$t=""}

    # for now we'll just assume that if the requested entity is not for cust projects, it is for partners
    # also, Product-related entities all start with A_Product
    if($CPModule.IndexOf($e) -ge 0){
        $module = $apiModule.CustomerProjects
    }else{
        if($e.Substring(0,9) -eq 'A_Product'){
            $module = $apiModule.Products
        }else{
            $module = $apiModule.BusinessPartners
        }
    }
     
    $uri = ($baseUrl+$module+$e+$countf+'?') + (($s,$f,$t -join '&') -replace "&+","&")
    write-host ">> Querying {$uri}"

    $rq = Invoke-WebRequest -Method $m -Uri $uri -Headers $headers -Body $b -WebSession $session

    if($cnt -eq $true){
        write-host "Count of records: $rq"
    }else{
        if($m.ToUpper() -eq 'GET'){

        if($o.Length -eq 0 -or $o -eq 'csv'){
          $json = $rq | ConvertFrom-Json
          $line = ''

          # output header
          foreach ($obj in $json.d.results[0].PSObject.Properties) {
                if($obj.Name -ne '__metadata'){$line += $obj.Name+";"}
          }
          $line += "`n"
          $json.d.results.forEach{
             foreach ($obj in $_.PSObject.Properties) {
                if($obj.Name -ne '__metadata'){
                    if($obj.Value.Length -eq 0){
                        $line += ";"
                    }else{
                        $line += ($obj.Value.toString())+";"
                    }
                }
            }
            $line += "`n"
          }
          write-output $line | Set-Clipboard
          if($noconsole.Length -eq 0){write-host $line}
        }
        if($o -eq 'json'){
          write-output (($rq | Format-Json)) | Set-Clipboard
          if($noconsole.Length -eq 0){write-host ($rq | Format-Json)}
        }
        }else{
          if($noconsole.Length -eq 0){write-host $rq} # patch/post response
        }
    }
}

function upload($m){
    $uri = $baseUrl + 'cpd/SC_PROJ_ENGMT_CREATE_UPD_SRV/ProjectSet?$top=1'
    # [1] get the CSRF token
    $headers = @{
        'Authorization' = $basicauth_header
        'X-CSRF-Token' = 'Fetch'
        'Content-Type' = 'application/json'   
    }
    $r = Invoke-WebRequest -Method Get -Uri $uri -Headers $headers -WebSession $session
    $token = $r.Headers['X-CSRF-Token']

    # [2] set the token in the new request
    $headers = @{
        'Authorization' = $basicauth_header
        'X-CSRF-Token' = $token
        'Content-Type' = 'application/json'   
        'Accept' = 'application/json' 
        'DataServiceVersion' = '2.0'
         # extra header would be required for internal projects
    }

    # $m = post or patch
    $null = $opendlg.ShowDialog()
    $o = ''
    $k = ''
    $fields = ''
    $payload = ''
    $hdr = ''
    foreach($line in Get-Content $opendlg.FileName) {
            if($hdr -eq ''){
                $hdr = $line.split(";")
                continue
            }
            $o = $line.split(";")[0]
            $k = $line.split(";")[1]
            if($CPModule.IndexOf($o) -ge 0){
                $module = $apiModule.CustomerProjects
            }else{
                if($o.Substring(0,9) -eq 'A_Product'){
                    $module = $apiModule.Products
                }else{
                    $module = $apiModule.BusinessPartners
                }
            }
            $payload = '{"d":{'
            for($f = 2; $f -lt $hdr.Length; $f++){
                $payload += '"'+ $hdr[$f] + '":"' + $line.Split(";")[$f]+'",'
            }
            $payload += '}}'
            $payload = ($payload -replace ",}}","}}")
            if($line.split(";")[1] -ne ''){
                if($k.IndexOf('=') -eq -1){
                    $k = "'$k'"
                }
                $k = "($k)"
            }
            $uri = $baseUrl + $module + $o + $k
            write-host ('>> ' + $m.ToUpper() + ' ' + $uri)
            if($m -ne 'test'){
                $rq = Invoke-WebRequest -method $m -Uri $uri -Headers $headers -Body $payload -WebSession $session
                write-host ('>> '+$rq.StatusCode+' '+$rq.StatusDescription)
            }
            # send request
            
    }
}

$q = "X"

while($q.Length -ne 0){
    $q = Read-Host '>> '
    if($q.Length -gt 0) {
        if($q -eq 'sample'){
            $q =  "hana -m 'get' -e 'ProjectSet' -s 'ProjectID,OrgID' -t 10"
        }
        Invoke-Expression $q
    }
} 
