function Get-OctoRepository() {
    #Connection variables
    $apikey = [System.Environment]::GetEnvironmentVariable('Octo-ApiKey', 'User')
    $OctopusURI = [System.Environment]::GetEnvironmentVariable('Octo-Uri', 'User')
    
    #Creating a connection
    $endpoint = [Octopus.Client.OctopusServerEndpoint]::new($OctopusURI, $apikey) 
    $repository = [Octopus.Client.OctopusRepository]::new($endpoint)
    Write-Output $repository
}