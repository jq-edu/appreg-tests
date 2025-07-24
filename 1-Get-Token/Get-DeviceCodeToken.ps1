## set variables (use Set-LocalDev.ps1 to set these variables) 
## app registration must be configure for public client

# define the scope for the access token
$scope = "https://analysis.windows.net/powerbi/api/.default" # Power BI scope
#$scope = "https://graph.microsoft.com/.default" # Graph API scope
#$scope = "https://database.windows.net/.default" # Azure SQL Database scope


### prepare body for device_code flow with microsoft identity
$deviceCodeAuthParams = @{
    Method = 'POST'
    Uri    = "https://login.microsoftonline.com/$TenantId/oauth2/v2.0/devicecode"
    Body   = @{
        client_id = $clientId
        scope     = $scope
    }
}

$deviceCodeRequest =  Invoke-RestMethod @deviceCodeAuthParams
Write-Host "$($DeviceCodeRequest.message)"
Read-Host "Press Enter once you have logged in from the browser to continue..."

### once logged in from the browser, get access token using a rest call (device_code flow)
$tokenRequestParams = @{
    Method = 'POST'
    Uri    = "https://login.microsoftonline.com/$TenantId/oauth2/v2.0/token"
    Body   = @{
        grant_type = "urn:ietf:params:oauth:grant-type:device_code"
        code       = $deviceCodeRequest.device_code
        client_id  = $clientId
    }
}
$tokenRequest = Invoke-RestMethod @tokenRequestParams
$accessToken = $tokenRequest.access_token
# send token to clipboard
$accessToken | Set-Clipboard