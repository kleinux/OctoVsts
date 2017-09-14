. "$PSScriptRoot\Test-Environment.ps1"
<#
.SYNOPSIS
Make a raw REST request against a VSTS instance

.DESCRIPTION
This is a pretty raw cmdlet and should probably have been left private, but maybe it helps someone.

.PARAMETER afterProject
Url fragment after the instance name

.PARAMETER version
Either 1.0 or 2.0 depending on the API endpoint

.EXAMPLE
# Get all repositories in the VSTS instance
$response = Get-RestVsts -U "_apis/git/repositories/" -V 1.0

.NOTES
General notes
#>
function Get-RestVsts {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)][Alias("U")]
        [string]$afterProject,
        [Parameter(Mandatory = $true)][Alias("V")]
        [string]$version
    )
    test-environment
    $v = Get-VstsConnection
    $url = "https://$($v.InstanceName).visualstudio.com/DefaultCollection/$($v.ProjectName)" 
    if (-not $afterProject.StartsWith("/")) {
        $url += '/'
    }
    $url += $afterProject
    if ($afterProject.IndexOf('?') -ne -1) {
        $url += "&"
    } else {
        $url += "?"
    }
    $url += "api-version=$version"
    $response = Invoke-RestMethod -Method Get -Uri $url -ContentType 'application/json' -Headers $v.RequestHeaders -Verbose:$VerbosePreference
    $response
}