## set variables (use Set-LocalDev.ps1 to set these variables)

# define the scope for the access token
#$scope = "https://analysis.windows.net/powerbi/api/.default" # Power BI scope
$scope = "https://graph.microsoft.com/.default" # Graph API scope

### get access token using a rest call (client_credential flow)
$tokenRequestParams = @{
    Method = 'POST'
    Uri    = "https://login.microsoftonline.com/$TenantId/oauth2/v2.0/token"
    Body = @{
        client_id = $clientId
        scope = $scope
        client_secret = $clientSecret
        grant_type = "client_credentials"
    } 
}
$authResult = Invoke-RestMethod @tokenRequestParams
$accessToken = $authResult.access_token

### add token to clipboard to inspect in jwt.ms
$accessToken | Set-Clipboard
