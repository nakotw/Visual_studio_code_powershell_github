install-module MSOnline
Import-Module MSOnline
Install-Module exchangeonlinemanagement
Import-Module exchangeonlinemanagement

#pour get-msoluser
Connect-MsolService

#pour get-mailbox
Connect-ExchangeOnline

#####
#attribue user aad all
#get-msoluser -UserPrincipalName "alain.larose@clarose.com" | Select-Object City,Country,Department,DisplayName,Fax,FirstName,LastName,MobilePhone,Office,PhoneNumber,PostalCode,ProxyAddresses,State,StreetAddress,Title,CustomAttribute1,CustomAttribute2,CustomAttribute3,CustomAttribute4,CustomAttribute5
#
get-msoluser | Select-Object Userprincipalname, City, Country, Department, DisplayName, Fax, FirstName, LastName, MobilePhone, Office, PhoneNumber, PostalCode, ProxyAddresses, State, StreetAddress, Title, CustomAttribute1, CustomAttribute2, CustomAttribute3, CustomAttribute4, CustomAttribute5 | ForEach-Object {
        write-host $_.Userprincipalname
        $var1 = $_.Userprincipalname
        $var2 = Get-ADUser -Filter 'Userprincipalname -eq $var1'
        write-host "$var1 test"
        $var2 | Set-ADUser -City $_.City -Country $_.Country -Department $_.Department -DisplayName $_.DisplayName -Fax $_.Fax -givenname $_.FirstName -surname $_.LastName -MobilePhone $_.MobilePhone -Office $_.Office -HomePhone $_.PhoneNumber -PostalCode $_.PostalCode -State $_.State -StreetAddress $_.StreetAddress -Title $_.Title
            
}
#####

#################################
#HideFromGAL
Import-Module ActiveDirectory
#$ou = "OU=user_o365,OU=gmti,DC=gmti,DC=local"
#Get-Mailbox -ResultSize Unlimited
#Get-Mailbox -ResultSize Unlimited | Where {$_.HiddenFromAddressListsEnabled -eq $True} | select-object windowsemailaddress | ForEach-Object {
Get-Mailbox -ResultSize Unlimited | select-object windowsemailaddress, alias | ForEach-Object {
    
        $var1 = $_.alias
        write-host $var1
        $var1 | Set-ADUser -Clear msDS-cloudExtensionAttribute1
        $var1 | Set-ADUser -add @{"msDS-cloudExtensionAttribute1" = "HideFromGAL" }
           
    
}
##################################
#customa
get-mailbox -identity "ridha.gagaa@clarose.com" | Select-Object Userprincipalname, Identity, CustomAttribute1, CustomAttribute2, CustomAttribute3, CustomAttribute4, CustomAttribute5 | ForEach-Object {
    
        #$var1 = $_.alias
        #$var1 = "mltest3"
        $var1 = $_.Userprincipalname.tostring()
        $var1=$var1.Split("@")[0]
        #$var2 = $_.Identity
        write-host "var1: "$var1
        #$var2 | Set-ADUser -City $_.City -Country $_.Country -Department $_.Department -DisplayName $_.DisplayName -Fax $_.Fax -givenname $_.FirstName -surname $_.LastName -MobilePhone $_.MobilePhone -Office $_.Office -HomePhone $_.PhoneNumber -PostalCode $_.PostalCode -State $_.State -StreetAddress $_.StreetAddress -Title $_.Title
        Set-ADUser -Identity $var1 -Clear extensionAttribute1, extensionAttribute2, extensionAttribute3, extensionAttribute4, extensionAttribute5
        #$var1 | Set-ADUser -Clear extensionAttribute1, extensionAttribute2, extensionAttribute3, extensionAttribute4, extensionAttribute5
        $attrib1 = $_.CustomAttribute1
        $attrib2 = $_.CustomAttribute2
        $attrib3 = $_.CustomAttribute3
        $attrib4 = $_.CustomAttribute4
        $attrib5 = $_.CustomAttribute5
        write-host "allo $($attrib1)"
        $var1 | Set-ADUser -add @{"extensionAttribute1" = $attrib1 }
        $var1 | Set-ADUser -add @{"extensionAttribute2" = $attrib2 }
        $var1 | Set-ADUser -add @{"extensionAttribute3" = $attrib3 }
        $var1 | Set-ADUser -add @{"extensionAttribute4" = $attrib4 }
        $var1 | Set-ADUser -add @{"extensionAttribute5" = $attrib5 }

        write-host $attrib1
             
}



#################################
#smtpalias
# fonctionnel !!!
Get-Mailbox -Identity "ridha.gagaa@clarose.com" | Select-Object alias, DisplayName, PrimarySmtpAddress, UserPrincipalName, @{Name = "Aliases"; Expression = { ($_.EmailAddresses | Where-Object { $_ -clike "smtp:*" -or $_ -clike "SMTP:*" }) } } | ForEach-Object {
        $var1 = $_.alias
        $var3 = $_.UserPrincipalName
        $var2 = Get-ADUser -Filter 'UserPrincipalName -like $var3'
        $var4 = $var2.SamAccountName
        $var5 = $_.Aliases
        if ($var5 -ne $null) {
                #$i = 0
                ForEach ($var5s in $var5) {
                        if ($var5s -like "*onmicrosoft.com") {
                                Write-Host "courriel microsoft skip $var5s"
                        }
                        else {
                                #$i++
                                #$i = $var5s
                                write-host $var5s
                                $var4 | Set-ADUser -add @{"proxyAddresses" = "$var5s" }
                        }
                }
                #$var1 | Set-ADUser -City $_.City -Country $_.Country -Department $_.Department -DisplayName $_.DisplayName -Fax $_.Fax -givenname $_.FirstName -surname $_.LastName -MobilePhone $_.MobilePhone -Office $_.Office -HomePhone $_.PhoneNumber -PostalCode $_.PostalCode -State $_.State -StreetAddress $_.StreetAddress -Title $_.Title
                #$var4 | Set-ADUser -Clear proxyAddresses
                #$var4 | Set-ADUser -add @{"proxyAddresses"="$var5"}
        }
        }

