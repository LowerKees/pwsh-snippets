<#
.SYNOPSIS

PowerShell implementation of the OAuth 2.0 client credentials flow
#>

$clientId = Read-Host "Input client app id"
$clientSecret = Read-Host "Input client secret"
$tenantId = Read-Host "Input tenant id"
$scope = Read-Host "For which scope are you requesting a token?"

$body = @{
    "client_id"     = $clientId;
    "client_secret" = $clientSecret;
    "scope"         = $scope;
    "grant_type"    = "client_credentials";
}

$headers = @{
    "Content-Type" = "application/json"
}

Invoke-WebRequest -Uri "https://login.microsoft.com/$tenantId/oauth2/v2.0/token" -Headers $headers -Body $body