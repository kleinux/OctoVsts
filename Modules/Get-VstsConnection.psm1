function Get-VstsConnection() {
    $r = @{}
    $r.InstanceName = [System.Environment]::GetEnvironmentVariable("Vsts-InstanceName", "User")
    $r.AccessToken = [System.Environment]::GetEnvironmentVariable("Vsts-AccessToken", "User")
    $r.ProjectName = [System.Environment]::GetEnvironmentVariable("Vsts-ProjectName", "User")
    $r.RequestHeaders = ConvertTo-VstsAuthorizationHeader $r.AccessToken
    return $r
}