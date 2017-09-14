<#
.SYNOPSIS
Pause script while an Octopus deployment completes

.DESCRIPTION
Displays a sequence of dots on the screen while the specified deployment runs. If deployment is successful this will write to the host the build status and deployment
time while writing to output $true. Otherwise writes Build failed in (time) and writes to output $false.

.PARAMETER deployment
If a string then should be a DeploymentResource Id or can be a DeploymentResource. Other types are not accepted.

.EXAMPLE
Wait-OctoDeployment -deployment 802

.NOTES
General notes
#>
function Wait-OctoDeployment {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        $deployment
    )
    begin {
        $repository = Get-OctoRepository
    }
    
    process {
        [string]$id = $null
        if ($deployment -is [string]){
            $id = $deployment
        } elseif ($deployment -is [Octopus.Client.Model.DeploymentResource]) {
            $id = $deployment.Id
        } else {
            Write-Error -Message "Unable to infer Id from deployment input '$deployment'"
            return
        }
        $found =  $repository.Deployments.Get($id)
        $done = $false
        $task = $null
        Write-Host -Object 'Waiting for deployment [' -NoNewline
        while (-not $done) {
            Write-Host -Object '.' -NoNewline
            $task = Get-RestOcto $found.Links.Task
            if ($task.IsCompleted) {
                $done = $true
            } else {
                Start-Sleep -Seconds 1
            }
        }
        Write-Host -Object ']'
        Write-Host $task.Description
        if ($task.FinishedSuccessfully) {
            Write-Host -ForegroundColor Green "$($task.State) in $($task.Duration)"
            Write-Output $true
        } else {
            Write-Host -ForegroundColor Red "Failed in $($task.Duration): $($task.ErrorMessage)"
            Write-Output $false
        }
    }
    
    end {
    }
}
