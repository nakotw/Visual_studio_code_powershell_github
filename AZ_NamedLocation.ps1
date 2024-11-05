Set-AzureADMSNamedLocationPolicy -PolicyId 76fdfd4d-bd80-4c1e-8fd4-6abf49d121fe -OdataType
Connect-AzureAD
Get-AzureADMSNamedLocationPolicy -PolicyId 1ed8a784-05d5-430a-bad7-33b3e8a7475f | Select-Object CountriesAndRegions | ft
["ZW", "ZM", "YE", "WF", "VI", "VG", "VN", "VE", "VU", "UZ", "UM", "UY", "US", "GB", "AE", "UA", "UG", "TV", "TC", "TM", "TR", "TN", "TT", "TO", "TK", "TG", "TL", "TH", "TZ", "TJ", "TW", "SY", "CH", "SE", "SZ", "SJ",
"SR", "SD", "LK", "ES", "SS", "GS", "ZA", "SO", "SB", "SI", "SK", "SX", "SG", "SL", "SC", "RS", "SN", "SA", "ST", "SM", "WS", "VC", "PM", "MF", "LC", "KN", "SH", "BL", "RW", "RU", "RO", "RE", "CG", "QA", "PR", "PT",
"PL", "PN", "PH", "PE", "PY", "PG", "PA", "PS", "PW", "PK", "OM", "NO", "MP", "MK", "KP", "NF", "NU", "NG", "NE", "NI", "NZ", "NC", "NL", "NP", "NR", "NA", "MM", "MZ", "MA", "MS", "ME", "MN", "MC", "MD", "FM", "MX",
"YT", "MU", "MR", "MQ", "MH", "MT", "ML", "MV", "MY", "MW", "MG", "MO", "LU", "LT", "LI", "LY", "LR", "LS", "LB", "LV", "LA", "KG", "KW", "XK", "KR", "KI", "KE", "KZ", "JO", "JE", "JP", "JM", "IT", "IL", "IM", "IE",
"IQ", "IR", "ID", "IN", "IS", "HU", "HK", "HN", "VA", "HM", "HT", "GY", "GW", "GN", "GG", "GT", "GU", "GP", "GD", "GL", "GR", "GI", "GH", "DE", "GE", "GM", "GA", "TF", "PF", "GF", "FR", "FI", "FJ", "FO", "FK", "ET",
"EE", "ER", "GQ", "SV", "EH", "EG", "EC", "DO", "DM", "DJ", "DK", "CD", "CZ", "CY", "CW", "CU", "HR", "CI", "CR", "CK", "KM", "CO", "CC", "CX", "CN", "CL", "TD", "CF", "KY", "CA", "CM", "KH", "CV", "BI", "BF", "BG",
"BN", "IO", "BR", "BV", "BW", "BA", "BQ", "BO", "BT", "BM", "BJ", "BZ", "BE", "BY", "BB", "BD", "BH", "BS", "AZ", "AT", "AU", "AW", "AM", "AR", "AG", "AQ", "AI", "AO", "AD", "AS", "DZ", "AL", "AX", "AF"]

Import-Module Microsoft.Graph.Identity.SignIns
Connect-MgGraph
Get-MgIdentityConditionalAccessNamedLocation -Filter "microsoft.graph.countryNamedLocation/countriesAndRegions/any(c: c eq 'CA')"

#####
#Import-Module Microsoft.Graph.Identity.SignIns
#Connect-MgGraph
#Get-MgIdentityConditionalAccessNamedLocation
#Get-MgIdentityConditionalAccessNamedLocation -NamedLocationId 1ed8a784-05d5-430a-bad7-33b3e8a7475f

$AccessToken = Invoke-RestMethod
Connect-MgGraph -Scopes 'Policy.ReadWrite.ConditionalAccess' -AccessToken $AccessToken
$connection = Connect-AzureAD
$AccessToken = $connection.access_token
$params = @{
	"@odata.type"                     = "#microsoft.graph.countryNamedLocation"
	DisplayName                       = "test pour list"
	CountriesAndRegions               = @(
		"AU"
		
	)
	IncludeUnknownCountriesAndRegions = $false
}

Update-MgIdentityConditionalAccessNamedLocation -NamedLocationId 1ed8a784-05d5-430a-bad7-33b3e8a7475f -BodyParameter $params



#####

# Populate with the App Registration details and Tenant ID
$appid = '6e10aa37-cebe-4779-8b41-53036d285bab'
$tenantid = '56bc28d8-9d91-479a-9426-65273e7a9fbf'
#$secret = 'f4082fb9-3573-4366-9407-e4d825f7e486'
$secret = 'Sj.8Q~m6zJjJBkKE4gmN50-3b4ha79YTfdmitb0Q'
 
$body = @{
	Grant_Type    = "client_credentials"
	Scope         = "https://graph.microsoft.com/.default"
	Client_Id     = $appid
	Client_Secret = $secret
}
 
$connection = Invoke-RestMethod `
	-Uri https://login.microsoftonline.com/$tenantid/oauth2/v2.0/token `
	-Method POST `
	-Body $body
 
$token = $connection.access_token
$Resultatt = $null
[array]$Resultatt= @()
$aliass = ("AL", "AX", "AF", "CA","")
$aliass.trimend(", ")
$Resultatt = @("AL AX AF CA")
$Resultatt = $Resultatt.Split("")
$Resultattt = @()
foreach ($R in $Resultatt) {
	$Resultattt += (,($R))
	
}
$Resultatt.GetType()
$Resultattt.GetType()
Connect-MgGraph -AccessToken $token
$params = @{
	"@odata.type"                     = "#microsoft.graph.countryNamedLocation"
	DisplayName                       = "test pour list"
	CountriesAndRegions               = @($Resultattt)
	IncludeUnknownCountriesAndRegions = $false
}
#Foreach ($R in $Resultatt){
###$CountriesAndRegions = @{}
#$CountriesAndRegions.add('@odata.type' , "#microsoft.graph.countryNamedLocation")
#$CountriesAndRegions.add($R, "$null")
#$params.CountriesAndRegions += $CountriesAndRegions
#}


Param(
[Parameter (Mandatory= $true)]
$Resultatt
)
#$Resultatt = $Resultatt.replace(",", "")
#$Resultatt = $Resultatt.replace('"', "")
#$Resultatt = $Resultatt.Insert(2,"`n")

# Populate with the App Registration details and Tenant ID
$appid = '6e10aa37-cebe-4779-8b41-53036d285bab'
$tenantid = '56bc28d8-9d91-479a-9426-65273e7a9fbf'
#$secret = 'f4082fb9-3573-4366-9407-e4d825f7e486'
$secret = 'Sj.8Q~m6zJjJBkKE4gmN50-3b4ha79YTfdmitb0Q'
 
$body = @{
	Grant_Type    = "client_credentials"
	Scope         = "https://graph.microsoft.com/.default"
	Client_Id     = $appid
	Client_Secret = $secret
}
[string]$Resultatt = $Resultatt
$Resultatt4 = $Resultatt.Split(",")
$Resultattt = $null
$Resultattt = @()
foreach ($R in $Resultatt4) {
    $R = $R.trimEnd()
    $R = $R.trimstart()
	$Resultattt += ($R)
	
}
 
$connection = Invoke-RestMethod `
	-Uri https://login.microsoftonline.com/$tenantid/oauth2/v2.0/token `
	-Method POST `
	-Body $body
$token = $connection.access_token
#Import-Module Microsoft.Graph.Identity.SignIns
Connect-MgGraph -AccessToken $token #-Scopes 'Policy.ReadWrite.ConditionalAccess'
$params = @{
"@odata.type" = "#microsoft.graph.countryNamedLocation"
DisplayName = "test pour list"
CountriesAndRegions = @($Resultattt)
IncludeUnknownCountriesAndRegions = $false
}
#Foreach ($R in $Resultatt){
#$CountriesAndRegions = @{}
#$CountriesAndRegions.add("@odata.type" , "#microsoft.graph.countryNamedLocation")
#$CountriesAndRegions.add("", $R)
#$params.CountriesAndRegions += $CountriesAndRegions
#}
#$apibody = Convertto-json -inputobject $body
Update-MgIdentityConditionalAccessNamedLocation -NamedLocationId "1ed8a784-05d5-430a-bad7-33b3e8a7475f" -BodyParameter $params
#get-MgIdentityConditionalAccessNamedLocation -NamedLocationId "1ed8a784-05d5-430a-bad7-33b3e8a7475f"
#Get-AzureADMSNamedLocationPolicy -PolicyId "1ed8a784-05d5-430a-bad7-33b3e8a7475f" | Select-Object CountriesAndRegions | ft
#Get-MgContext
#Get-MgContext | Select-Object -ExpandProperty Scopes
#$Resultatt
#Disconnect-MgGraph
$Resultatt
#$Resultatt2
$Resultattt
$Resultatt4
