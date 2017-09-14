function Get-VstsBuildDefinitions {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, HelpMessage = 'Search string to limit project by name')]
        [string]$name = $null, 
        [Parameter(Mandatory = $false, HelpMessage = 'Build configuration type')]
        [ValidateSet('build', 'xaml')]
        [string]$type = $null
    )
    $v = Get-VstsConnection
    $url = "https://$($v.InstanceName).visualstudio.com/DefaultCollection/$($v.ProjectName)/_apis/build/definitions?api-version=2.0"
    if ($PSBoundParameters.ContainsKey('name')) { $url += '&name=' + [Uri]::EscapeDataString($name) }
    if ($PSBoundParameters.ContainsKey('type')) { $url += '&type=' + [Uri]::EscapeDataString($type) }
    $response = Invoke-RestMethod -Method Get -Uri $url -ContentType 'application/json' -Headers $v.RequestHeaders -Verbose:$VerbosePreference 
    $hash = @{}
    $response.value | ForEach-Object { $hash[$_.name] = $_.id }
    
    Write-Output $hash
}