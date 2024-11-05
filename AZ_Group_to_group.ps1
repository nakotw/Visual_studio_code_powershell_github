# Définir les informations de connexion
$credential = Get-Credential

# Connectez-vous au service Microsoft 365
Connect-MsolService -Credential $credential

# Spécifiez le nom des groupes source et cible
$nomGroupeSource = "NomDuGroupeSource"
$nomGroupeCible = "NomDuGroupeCible"

# Récupérez les membres du groupe source
$membresGroupeSource = Get-MsolGroupMember -GroupObjectId (Get-MsolGroup -SearchString $nomGroupeSource).ObjectId

# Ajoutez chaque membre au groupe cible
foreach ($membre in $membresGroupeSource) {
    Add-MsolGroupMember -GroupObjectId (Get-MsolGroup -SearchString $nomGroupeCible).ObjectId -GroupMemberObjectId $membre.ObjectId -GroupMemberType $membre.ObjectType
}

Write-Host "Les membres ont été ajoutés avec succès au groupe cible."
