function Initialize-OctoVsts {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, Position=0)]
        [string]$VstsInstance,
        [Parameter(Mandatory=$true, Position=1)]
        [string]$VstsProject,
        [Parameter(Mandatory=$true, Position=2)]
        [string]$VstsAccessToken,
        [Parameter(Mandatory=$true, Position=3)]
        [string]$OctoApiKey,
        [Parameter(Mandatory=$true, Position=4)]
        [uri]$OctoUri
    )
    Set-VstsConnection -instanceName $VstsInstance -projectName $VstsProject -accessToken $VstsAccessToken
    Set-OctoConnection -apiKey $OctoApiKey -uri $OctoUri
}