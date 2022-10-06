<#
.DESCRIPTION
Searches through text files in a specific directory and returns full file paths
if there is a match.
#>

[CmdletBinding()]
param (
    [Parameter(
        Mandatory = $true,
        HelpMessage = "Key word to search for in files"
    )]
    [string]
    $Keyword,
    [Parameter(
        Mandatory = $false,
        HelpMessage = "Search recursively through any child directories in the current directory"
    )]
    [switch]
    $Recurse = $false
)

if ($Recurse) { $files = Get-ChildItem -File -Recurse } else { $files = Get-ChildItem -File }

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName
    if ($content -match $Keyword) {
        Write-Host "Found string '$Keyword'in file $($file.FullName)"
    }
}