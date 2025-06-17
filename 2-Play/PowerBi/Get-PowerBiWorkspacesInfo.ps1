### retrouver les lineage d'un dataset en utilisant le graph via une requete rest
# nécessite d'avoir les permissions suivantes : 
# tenant.read.all, workspace.read.all


$headers = @{
    Authorization = "Bearer $accessToken"
}


# get list of all workspaces
$uri = "$powerBiBaseUrl/admin/workspaces/modified"
$workspaces = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get
$workspaces

# trigger scan for workspace information including lineage and datasource details (max 100 workspaces at a time)
$uri = "$powerBiBaseUrl/admin/workspaces/getInfo"
$body = @{
    workspaces = $workspaces.id
    lineage = $true
    datasourceDetails = $true
}
$jsonBody = $body | ConvertTo-Json
$result = Invoke-RestMethod -Uri $uri -Headers $headers -Method POST -Body $jsonBody -ContentType "application/json"
$result

# get scan status for the workspace information scan
$uri = "$powerBiBaseUrl/admin/workspaces/scanStatus/$($result.id)"
# call and wait for the scan to complete
while ($scanStatus.status -ne "Succeeded") {
    Start-Sleep -Seconds 10
    $scanStatus = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get
    Write-Host "Current scan status: $($scanStatus.status)"
}

# get scan result for the workspace information scan - must wait Succeeded status from previous step
$uri = "$powerBiBaseUrl/admin/workspaces/scanResult/$($scanStatus.id)"
$scanResult = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get
$scanResult
#export all as json content
$scanResult | ConvertTo-Json -Depth 10 | Out-File -FilePath "C:\temp\scanResult.json" -Encoding utf8