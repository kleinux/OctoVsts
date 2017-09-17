function Publish-OctoDeployment {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, Position=0)]
        [string]$version,
        [Parameter(Mandatory=$false, Position=1)]
        [string]$environmentName = "INT" 
    )
    $repository = Get-OctoRepository
    $environment = $repository.Environments.FindByName($environmentName)

    $toDeploy = $repository.Releases.FindOne({ param($r) $r.Version -eq $version }) 
    if ($toDeploy -eq $null) { throw "No release found with version '$version'" }

    $deployment = [Octopus.Client.Model.DeploymentResource]::new()
    $deployment.ReleaseId = $toDeploy.Id
    $deployment.ProjectId = $toDeploy.ProjectId
    $deployment.EnvironmentId = $environment.Id
    
    $repository.Deployments.Create($deployment)
}