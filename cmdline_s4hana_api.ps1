# this version now works with shorthands (-e,-m,-f…)
# f - filter -o out
# s - select -e entity
# t - top -m method
# also adds -noconsole
# + couple of fixes

Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass -Force
$session = new-object microsoft.powershell.commands.webrequestsession

$apiModule = @{
    "CustomerProjects" = "cpd/SC_PROJ_ENGMT_CREATE_UPD_SRV/"
    "BusinessPartners" = "sap/API_BUSINESS_PARTNER/"
    "InternalProjects" = "sap/API_ENTERPRISE_PROJECT_SRV;v=0002/"
    "Products" = "sap/API_PRODUCT_SRV/"
}

$CPModule = "A_CustProjSlsOrd,A_CustProjSlsOrdItem,A_CustProjSlsOrdItemPartner,A_CustProjSlsOrdItemText,A_CustProjSlsOrdItemWorkPckg,A_CustProjSlsOrdItmBillgPlnItm,A_CustProjSlsOrdPartner,A_CustProjSlsOrdText,A_EngmntProjRsceDmnd,A_EngmntProjRsceDmndDistr,A_EngmntProjRsceDmndSkill,A_EngmntProjRsceSup,A_EngmntProjRsceSupDistr,WorkPackageFunctionSet,ProjectSet,WorkPackageSet,WorkItemSet,DemandSet,ProjectRoleSet"

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
 
# -- S/4 TENANT ---
$user = ‘API_USER'
$pwd = ‘API_PWD’
$baseUrl = 'https://myXXXXXX.s4hana.ondemand.com/sap/opu/odata/'
$creds = $user+":"+$pwd
$encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($creds))
$basicauth_header = "Basic $encodedCreds"
$uri = $baseUrl + 'cpd/SC_PROJ_ENGMT_CREATE_UPD_SRV/ProjectSet?$top=1' # only to get the token

# need a mapping table so we don't have to indicate the module (only the entity)

function hana($m,$e,$s,$f,$t,$b,$o,$cnt,$noconsole){

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
    write-host ">> Querying S/4HANA {$uri}"

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
                if($obj.Name -ne '__metadata'){$line += ($obj.Value.toString())+";"}
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

$q = "X"

while($q.Length -ne 0){
    $q = Read-Host '>> '
    if($q.Length -gt 0) {
       if($q -eq 'sample'){
            $q =  "hana -method 'get' -entity 'ProjectSet' -select 'ProjectID,OrgID' -top 10"
         }
        Invoke-Expression $q
    }
}

<#
Examples:
hana -method 'get' -entity 'ProjectSet' -select 'ProjectID,OrgID,CreatedOn' -top 10
hana -entity 'ProjectSet' -select 'ProjectID,OrgID,CreatedOn' -top 10
hana -method 'get' -entity 'ProjectSet' -select 'ProjectID,OrgID' -top 10 -filter "Project ID eq '00000035'"
hana -entity 'A_Customer' -select 'Customer,CustomerFullName' -top 10
hana -entity 'A_Customer' -cnt true
hana -entity 'A_Product' -top 10 -select 'ProductType,Product'
hana -entity 'ProjectSet' -top 10 -filter "startswith(Project ID, 'D60')" -cnt true
hana -entity 'ProjectSet' -top 100 -noconsole 1
hana -e 'ProjectSet' -t 100 -noconsole 1

Update:
hana -m 'patch' -e "A_Customer('1000000')" -b '{"d":{"TrainStationName":"Test"}}'

Notes:
* method 'get' by default
* output 'csv' by default
* with parameter cnt = true (count), select and top parameters will be removed
#>
