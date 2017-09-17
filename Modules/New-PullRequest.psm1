. "$PSScriptRoot\New-DynamicParam.ps1"
<#
.SYNOPSIS
Create a pull request in VSTS

.DESCRIPTION
Create a pull request in VSTS

.PARAMETER title
The top level text for the pull request

.PARAMETER description
Describe the purpose of this pull request

.PARAMETER sourceRefName
the refs/heads/branch-name to merge from

.PARAMETER targetRefName
the refs/heads/branch-name to merge into

.PARAMETER reviewers
a string array of users to review this pull request. Users must be specified by uniqueName, which is probably email address.

.PARAMETER repository
The GIT repository this pull request belongs to. This is the logical name of the repo in VSTS, so usually the thing that comes after /_git/ in the url. If running this function in this repo then this parameter can be inferred and is not needed.

.EXAMPLE
New-PullRequest -targetRefName master -title 'a great pull request' -description 'This really cleans up the code' -pipe

.NOTES
General notes
#>
function New-PullRequest {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true)]
        [string]$title,
        [Parameter(Mandatory = $true)]
        [string]$description,
        [Parameter(Mandatory = $false)]
        [string]$repository
    )
    DynamicParam {
        $params = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
        if ([string]::IsNullOrWhiteSpace($repository)) {
            $repository = Get-CurrentGitRepository
        }
        $refs = (Get-RestVsts -U "_apis/git/repositories/$repository/refs" -version 1.0).value
        New-DynamicParam -Name sourceRefName -ValidateSet @($refs | ForEach-Object { $_.name} | Sort-Object ) -DPDictionary $params
        New-DynamicParam -Name targetRefName -ValidateSet @($refs | ForEach-Object { $_.name} | Sort-Object ) -DPDictionary $params

        if ($MyInvocation.MyCommand.Module.PrivateData.users -eq $null) {
            $MyInvocation.MyCommand.Module.PrivateData.users = @{}
            foreach ($project in Get-RestVsts -afterProject '_apis/projects' -version 1.0 -np | Select-Object -ExpandProperty value) {
                foreach ($team in Get-RestVsts -afterProject "_apis/projects/$($project.id)/teams" -np -version 1.0 | Select-Object -ExpandProperty value) {
                    foreach ($user in Get-RestVsts -afterProject "_apis/projects/$($project.id)/teams/$($team.id)/members" -np -version 1.0 | Select-Object -ExpandProperty value) {
                        $MyInvocation.MyCommand.Module.PrivateData.users[$user.uniqueName] = $user.id
                    }
                }
            }
        }
        New-DynamicParam -Name reviewers -ValidateSet $MyInvocation.MyCommand.Module.PrivateData.users.keys -DPDictionary $params -type string[]
        return $params
    }
    begin {
        $sourceRefName = $PSBoundParameters['sourceRefName']
        if ([string]::IsNullOrWhiteSpace($sourceRefName)) {
            $sourceRefName = git symbolic-ref HEAD
        }
        $targetRefName = $PSBoundParameters['targetRefName']
        $reviewers = $PSBoundParameters['reviewers']
        if ([string]::IsNullOrWhiteSpace($repository)) {
            $repository = Get-CurrentGitRepository
        }
    }
        
    process {
        $reviewerGuilds = @()
        if ($reviewers.Length -gt 0) {
            $users = $MyInvocation.MyCommand.Module.PrivateData.users
            $reviewerGuilds += $reviewers | ForEach-Object { @{id=$users[$_]} }
        }
        $body = @{ 
            sourceRefName = $sourceRefName;
            targetRefName = $targetRefName;
            title         = $title;
            description   = $description;
            reviewers     = $reviewerGuilds;
        }
        $pullRequest = Post-RestVsts -afterProject "_apis/git/repositories/$repository/pullRequests" -body $body -version '3.0-preview' -Verbose:$VerbosePreference -WhatIf:$WhatIfPreference
        Write-Output $pullRequest
    }
        
    end {
    }
}

function Get-CurrentGitRepository{
    $repository = git config --get remote.origin.url
    $repository = $repository.Substring(1 + $repository.LastIndexOf('/'))
    Write-Output $repository
}