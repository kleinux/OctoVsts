function Set-OctoConnection {
    param (
        [Parameter(Mandatory=$true, Position = 0)]
        [string]$apiKey,
        [Parameter(Mandatory=$true, Position=1)]
        [uri]$uri
    )
    [System.Environment]::SetEnvironmentVariable('Octo-ApiKey', $apiKey, 'User')
    [System.Environment]::SetEnvironmentVariable('Octo-Uri', $uri, 'User')
}