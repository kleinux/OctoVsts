<#
.SYNOPSIS
Makes a raw REST request to the configured Octopus instance

.DESCRIPTION
Perform a GET request against the given path fragment of the configured Octopus instance

.PARAMETER path
The API resource to get

.EXAMPLE
Get-RestOcto '/api/users/me'

.NOTES
You must have configured OctoVsts to use this with Initialize-OctoVsts
#>
function Get-RestOcto {
    param (
        [string] $path
    )
    $apikey = [System.Environment]::GetEnvironmentVariable('Octo-ApiKey', 'User')
    $OctopusURI = [System.Environment]::GetEnvironmentVariable('Octo-Uri', 'User')

    $url = $OctopusURI + $path
    Invoke-RestMethod -Method Get -Uri $url -Headers @{ "X-Octopus-ApiKey" = $apikey } -Verbose:$VerbosePreference
}