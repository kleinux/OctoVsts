function Initialize-OctoVstsDefaults {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$vstsBuildDefinition,
        [Parameter(Mandatory=$true, Position=1)]
        [string]$OctoDefaltEnvironment
    )
    $path = git rev-parse --show-toplevel
    if ($LASTEXITCODE -ne 0) {
        Write-Error -Message "Initalize-OctoVstsDefaults must be called from within a git repository"
        return
    }
    $fullpath = Join-Path -path $path -childPath 'OctoVsts.json'
    $hash = @{ VstsBuildDefinition = $vstsBuildDefinition; OctoDefaultEnvironment=$OctoDefaltEnvironment }
    ConvertTo-Json -InputObject $hash | Out-File -FilePath $fullpath
}