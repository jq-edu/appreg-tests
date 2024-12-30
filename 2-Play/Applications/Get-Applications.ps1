### retrouver les app registration en utilisant le graph via une requete rest
# nécessite d'avoir les permissions suivantes :
# - pour device code flow - Application.Read.All (Delegated)
# - pour client credentials flow - Application.Read.All (Application)

$uri = "$graphBaseUrl/applications"
$headers = @{
    Authorization = "Bearer $accessToken"
}
$appRegistrations = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get

# afficher les app registration
$appRegistrations.value | ForEach-Object {
    Write-Output ("App registration: " + $_.displayName)
}