$headers = @{
    Authorization = "Bearer $accessToken"
}

# get list of all workspaces
$uri = "$powerBiBaseUrl/groups"
$workspaces = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get
foreach ($workspace in $workspaces.value) {
    Write-Host "Workspace ID: $($workspace.id), Name: $($workspace.name)"
}
$workspaceId = "..."

# get list of all datasets in one workspace
$uri = "$powerBiBaseUrl/groups/$workspaceId/datasets"
$datasets = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get
foreach ($dataset in $datasets.value) {
    Write-Host "Dataset ID: $($dataset.id), Name: $($dataset.name)"
}
$datasetId = "..."

# get dataset
$uri = "$powerBiBaseUrl/groups/$workspaceId/datasets/$datasetId"
$dataset = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get
$dataset.value | Format-List

#get data from dataset table
$tableName = "Accounts"
$uri = "$powerBiBaseUrl/groups/$workspaceId/datasets/$datasetId/executeQueries"
$daxQuery = "{`"queries`":[{`"query`":`"EVALUATE VALUES($tableName)`"}]}"
$data = Invoke-RestMethod -Uri $uri -Headers $headers -Method Post -Body $daxQuery -ContentType "application/json"
$table = $data.results[0].tables[0]
$table.rows | Format-Table -AutoSize


