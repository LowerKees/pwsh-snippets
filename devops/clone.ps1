$REPOSROOT = "/home" # Fill in desired root location
$USERPAT = "" # Fill in user PAT from Azure DevOps with permission to read and list the repositories
$ORG = "" # Your Azure DevOps organization name
$PROJECT = "" # Your Azure DevOps project name containing the repos

# If you want to ignore stuff, add them to the list below or replace a placeholder
$IGNORELIST = @(
    "not-this-repo-1",
    "not-this-repo-2",
    "not-this-repo-n"
)

# No need to modify below this line

$pat = ":$USERPAT"

$bytes = [System.Text.Encoding]::ASCII.GetBytes($pat)
$pat64 = [Convert]::ToBase64String($bytes)

$uri = "https://dev.azure.com/$ORG/$PROJECT/_apis/git/repositories?api-version=7.1-preview.1"
$headers = @{
    "Authorization" = "Basic $pat64"
    "Content-Type"  = "application/json"
}

$response = Invoke-WebRequest -Method GET -Uri $uri -Headers $headers
$repos = $response.Content | ConvertFrom-Json

Set-Location -Path $REPOSROOT -ErrorAction Stop
foreach ($repo in $repos.value) {
    if ($repo.name -in $IGNORELIST) {
        Write-Host "Ignoring repo $($repo.name)"
        continue
    }

    if (!(Test-Path $repo.name)) {
        git clone $repo.sshUrl
    }
    else {
        Write-Host "Repo $($repo.name) already exists."
    }
}
