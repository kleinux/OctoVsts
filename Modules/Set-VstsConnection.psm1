function Set-VstsConnection {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$instanceName,
        [Parameter(Mandatory = $true)]
        [string]$projectName,
        [Parameter(Mandatory = $true)]
        [string]$accessToken
    )
    [System.Environment]::SetEnvironmentVariable("Vsts-InstanceName", $instanceName, "User")
    [System.Environment]::SetEnvironmentVariable("Vsts-ProjectName", $projectName, "User")
    [System.Environment]::SetEnvironmentVariable("Vsts-AccessToken", $accessToken, "User")
}