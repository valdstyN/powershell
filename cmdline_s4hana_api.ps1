CLS
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass -Force
$session = new-object microsoft.powershell.commands.webrequestsession

$apiModule = @{
    "CustomerProjects" = "cpd/SC_PROJ_ENGMT_CREATE_UPD_SRV/"
    "BusinessPartners" = "sap/API_BUSINESS_PARTNER/"
    "InternalProjects" = "sap/API_ENTERPRISE_PROJECT_SRV;v=0002/"
    "Products" = "sap/API_PRODUCT_SRV/"
}
$CPModule = @(
    "A_CustProjSlsOrd"
    "A_CustProjSlsOrdItem"
    "A_CustProjSlsOrdItemPartner"
    "A_CustProjSlsOrdItemText"
    "A_CustProjSlsOrdItemWorkPckg"
    "A_CustProjSlsOrdItmBillgPlnItm"
    "A_CustProjSlsOrdPartner"
    "A_CustProjSlsOrdText"
    "A_EngmntProjRsceDmnd"
    "A_EngmntProjRsceDmndDistr"
    "A_EngmntProjRsceDmndSkill"
    "A_EngmntProjRsceSup"
    "A_EngmntProjRsceSupDistr"
    "WorkPackageFunctionSet"
    "ProjectSet"
    "WorkPackageSet"
    "WorkItemSet"
    "DemandSet"
    "ProjectRoleSet"
)

# code from the interweb
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
$user = 'API_USER'
$pwd = 'API_PASSWORD'
$baseUrl = 'https://myXXXXXX.s4hana.ondemand.com/sap/opu/odata/'
$creds = $user+":"+$pwd
$encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($creds))
$basicauth_header = "Basic $encodedCreds"
$uri = $baseUrl + 'cpd/SC_PROJ_ENGMT_CREATE_UPD_SRV/ProjectSet?$top=1' # only to get the token

# need a mapping table so we don't have to indicate the module (only the entity)

function hana($method,$entity,$select,$filter,$top,$body,$out,$cnt){

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
        # extra header required for internal projects
    }

    if($cnt -eq $true){
        $countf='/$count'
        $top=''
        $select=''
    }else{
        $countf=''
    }
    if($method.Length -eq 0){$method='get'}
    if($select.Length -ne 0){$select='$select='+$select}else{$select=""}
    if($filter.Length -ne 0){$filter='$filter='+$filter}else{$filter=""}
    if($top.Length -ne 0){$top='$top='+$top}else{$top=""}
    
    # for now we'll just assume that if the requested entity is not for cust projects, it is for partners
    # also, Product-related entities all start with A_Product
    if($CPModule.IndexOf($entity) -ge 0){
        $module = $apiModule.CustomerProjects
    }else{
        if($entity.Substring(0,9) -eq 'A_Product'){
            $module = $apiModule.Products
        }else{
            $module = $apiModule.BusinessPartners
        }
    }
       
    $uri = ($baseUrl+$module+$entity+$countf+'?') + (($select,$filter,$top -join '&') -replace "&+","&")
    write-host ">> Querying S/4HANA {$uri}"
    $rq = Invoke-WebRequest -Method $method -Uri $uri -Headers $headers -Body $body -WebSession $session

    if($cnt -eq $true){
        write-host "Count of records: $rq"
    }else{
        if($out.Length -eq 0 -or $out -eq 'csv'){
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
          write-host $line
        }
        if($out -eq 'json'){
          write-output (($rq | Format-Json)) | Set-Clipboard
          write-host ($rq | Format-Json)
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

Notes:
* method 'get' by default
* output 'csv' by default
* with parameter cnt = true (count), select and top parameters will be removed

#>
