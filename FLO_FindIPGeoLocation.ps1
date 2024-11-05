#requires -Version 3 
$source = [string]$args[0] 
$infoService = "http://freegeoip.net/xml/$source" 
$geoip = Invoke-RestMethod -Method Get -URI $infoService 
$geoip.Response