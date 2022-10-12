
cls
$xsdname = Read-Host "XSD Template name"
$csv = Read-Host "List of fields (comma-separated)"

$xsddata= ""
$xsddata += "<?xml version=`"1.0`" encoding=`"UTF-8`"?>`n"
$xsddata += "<xs:schema xmlns:xs=`"http://www.w3.org/2001/XMLSchema`" elementFormDefault=`"qualified`">`n"
$xsddata += "<xs:element name=`"Records`">`n"
$xsddata += "  <xs:complexType>`n"
$xsddata += "    <xs:sequence>`n"
$xsddata += "      <xs:element name=`"Record`" maxOccurs=`"unbounded`">`n"
$xsddata += "        <xs:complexType>`n"
$xsddata += "		<xs:sequence>`n"
for($f=0; $f -lt $csv.Split(",").Length;$f++){
$v = $csv.Split(",")[$f]
$xsddata += "		<xs:element name=`"$v`" type=`"xs:string`" maxOccurs=`"1`" minOccurs=`"0`" />`n"
}	  
$xsddata += "		</xs:sequence>`n"
$xsddata += "        </xs:complexType>`n"
$xsddata += "      </xs:element>`n"
$xsddata += "    </xs:sequence>`n"
$xsddata += "  </xs:complexType>`n"
$xsddata += "</xs:element>`n"
$xsddata += "</xs:schema>`n"

$p = $PSScriptRoot
$xsddata = $xsddata > ($p+'\'+$xsdname+'.xsd')