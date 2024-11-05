# Importer le module nécessaire
Import-Module Microsoft.Graph

# Connexion à Microsoft 365
Connect-MgGraph -Scopes "User.Read.All", "Group.Read.All"

# Charger le fichier CSV
$groups = Import-Csv -Path "C:\Temp\QSL\qslmfagroupenabled.csv"

# Obtenir la liste des utilisateurs
$users = Get-MgUser -All

# Initialiser un tableau pour stocker les résultats
$results = @()

foreach ($group in $groups) {
    # Récupérer les membres du groupe
    $groupMembers = Get-MgGroupMember -GroupId (Get-MgGroup -Filter "displayName eq '$($group.GroupName)'").Id -ErrorAction SilentlyContinue
    
    if ($null -ne $groupMembers) {
        foreach ($user in $users) {
            # Vérifier si l'utilisateur n'est pas membre du groupe
            if (-not ($groupMembers | Where-Object { $_.Id -eq $user.Id })) {
                # Ajouter à la liste des résultats
                $results += [PSCustomObject]@{
                    UserPrincipalName = $user.UserPrincipalName
                    GroupName         = $group.GroupName
                }
            }
        }
    } else {
        Write-Host "Groupe '$($group.GroupName)' introuvable."
    }
}

# Exporter les résultats dans un fichier CSV
$results | Export-Csv -Path "C:\Temp\QSL\results_non_group_users.csv" -NoTypeInformation

Write-Host "Vérification terminée. Les résultats ont été exportés vers results.csv."
