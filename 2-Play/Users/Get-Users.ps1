### retrouver les utilisateur en utilisant le graph via une requete rest
# nécessite d'avoir les permissions suivantes :
# - pour device code flow - User.Read.All (Delegated)
# - pour client credentials flow - User.Read.All (Application)

$uri = "$graphBaseUrl/users"
$headers = @{
    Authorization = "Bearer $accessToken"
}
$users = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get

# afficher les utilisateurs
$users.value | ForEach-Object {
    Write-Output ("User: " + $_.displayName)
}