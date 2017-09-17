<#
.SYNOPSIS
Monitors the latest build for a given build definition and if successful then deploys it using Octopus Deploy.

.DESCRIPTION
Long description

.PARAMETER environment
The Octopus Environment to deploy to

.PARAMETER sourceBranch
The branch to build and deploy. If not specified then the currently checkedout branch is used.

.PARAMETER force
If specified then no confirmation to deploy Octopus is shown

.EXAMPLE
Publis-Build -sourceBranch develop

.NOTES
General notes
#>
function Publish-Build {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High", PositionalBinding = $true)]
    param (
        [Parameter(Mandatory = $false, Position = 0)]
        [string]$environment,
        [Parameter(Mandatory = $false, Position = 1)]
        [string]$sourceBranch,
        [Parameter(Mandatory = $false, Position = 2)]
        [switch]$force = $false
    )
    if (-not (Test-Path -Path .\OctoVsts.json)) {
        Write-Error "Using Publish-Build requires a OctoVsts.json settings file"
        return
    }
    $settings = get-content -Path .\OctoVsts.json -Raw | ConvertFrom-Json
    if (-not $PSBoundParameters.ContainsKey('environment')) {
        $environment = $settings.OctoDefaultEnvironment
    }
    if (-not $PSBoundParameters.ContainsKey('sourceBranch')) {
        $sourceBranch = git symbolic-ref HEAD
    }
    if ([string]::IsNullOrWhiteSpace($sourceBranch)) {
        Write-Error -Message "No branch specified nor executing within a git repository."
        return
    }
    if (-not $sourceBranch.StartsWith("refs/heads/", [StringComparison]::OrdinalIgnoreCase)) {
        $sourceBranch = "refs/heads/" + $sourceBranch   
    }
    $build = Get-VstsRecentBuilds -build $settings.VstsBuildDefinition -recent 10 | Where-Object { $_.SourceBranch -eq $sourceBranch } | Select-Object -First 1
    if ($build -eq $null) {
        Write-Error -Message "No build found for branch '$sourceBranch'" -Category ObjectNotFound
        return;
    }
    $buildResult = Wait-VstsBuild $settings.VstsBuildDefinition -buildNumber $build.BuildNumber -pipeBuild
    $buildResult | Write-Verbose -Verbose:$VerbosePreference
    if ($buildResult.result -ne "succeeded") {
        Write-Host "Build result: $($buildResult.result)" -ForegroundColor Red
        return
    }
    Write-Host "Build result: $($buildResult.result)" -ForegroundColor Green
    $reason = [System.Management.Automation.ShouldProcessReason]::None
    $message = "Ready to octopus deploy '$($build.BuildNumber)' to '$environment'?"
    if ($force -or $PSCmdlet.ShouldProcess('', '', $message, [ref]$reason)) {
        Publish-OctoDeployment -environmentName $environment -version $build.BuildNumber | Wait-OctoDeployment
    }
}