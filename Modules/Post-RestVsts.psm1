. "$PSScriptRoot\Test-Environment.ps1"
function Post-RestVsts {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)][Alias("U")]
        [string]$afterProject,
        [Parameter(Mandatory = $false)]
        [hashtable]$vars = $null,
        [Parameter(Mandatory = $true)][Alias("V")]
        [string]$version,
        [Parameter(Mandatory=$false)]
        $body
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
    if ($vars -eq $null) { $vars = @{}}
    $vars['api-version']=$version;
    
    $url += (($vars.GetEnumerator() | ForEach-Object { "$($_.key)=$($_.value)" }) -join '&') 
    Write-Verbose $url
    $json = ConvertTo-Json $body
    Write-Verbose $json
    if ($WhatIfPreference -ne $true) {
        $response = Invoke-RestMethod -Method Post -Uri $url -ContentType 'application/json' -Headers $v.RequestHeaders -Verbose:$VerbosePreference -Body $json
        $response    
    }
}