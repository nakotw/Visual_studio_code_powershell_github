Get-ChildItem $env:LOCALAPPDATA\Microsoft\Outlook\* -Include *.ost, *.nst, *.pst | Remove-Item
Set-Location HKCU:
$Profiles = Get-ChildItem 'HKCU:\SOFTWARE\Microsoft\Office\16.0\Outlook\Profiles' |foreach {
    Get-ChildItem $_.Name |foreach {
        Get-ChildItem -Path $_.Name
    } 
}
 
foreach($Profile in $Profiles){
    try{
        $AccountName = Get-ItemPropertyValue -Path $Profile.Name -Name 'Account Name' -ErrorAction Stop
        if($AccountName -like '*@*'){
            'HKCU:\' + ($Profile.Name.Split('\')[1..7] -join '\') | Remove-Item -Recurse
        }
    }catch{
        Continue
    }
}