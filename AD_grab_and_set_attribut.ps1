
Import-Module ActiveDirectory
#$ou = "OU=user_o365,OU=gmti,DC=gmti,DC=local"

Get-ADUser -SearchBase $ou -filter * -Properties EmailAddress, telephoneNumber, HomePhone | ForEach-Object {
    if (![string]::IsNullOrEmpty($_.telephoneNumber)) { 
        Write-Host "Changement ADUser -UserPrincipalName "$_.EmailAddress $_.telephoneNumber $_.HomePhone
        $product_code = $_.telephoneNumber
        $phoneExt = $product_code.SubString($product_code.Length - 3)
        $_ | Set-ADUser -HomePhone "+14186586624x$($phoneExt)"
        write-host "+14186586624x$($phoneExt)"        
    }
    else {
        write-host "Attribue telephonenumber est vide"
    }
}