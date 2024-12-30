## set variables (use Set-LocalDev.ps1 to set these variables)

### get access token using a rest call (client_credential flow)
$tokenRequestParams = @{
    Method = 'POST'
    Uri    = "https://login.microsoftonline.com/$TenantId/oauth2/v2.0/token"
    Body = @{
        client_id = $clientId
        scope = "https://graph.microsoft.com/.default"
        client_secret = $clientSecret
        grant_type = "client_credentials"
    } 
}
$authResult = Invoke-RestMethod @tokenRequestParams
$accessToken = $authResult.access_token

### add token to clipboard to inspect in jwt.ms
$accessToken | Set-Clipboard
