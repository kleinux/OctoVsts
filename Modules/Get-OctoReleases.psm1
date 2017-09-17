function Get-OctoReleases ([int]$recent = 4, [string]$projectName) { 
    
    $repository = Get-OctoRepository
    $project = $repository.Projects.FindByName($projectName)
    if ($project -eq $null) { throw "No project found named '$projectName'" }

    $all = $repository.Releases.FindMany({ param($r) $r.ProjectId -eq $project.Id}) 
    $rt =  [Octopus.Client.Model.TaskResource]

    for ($i = 0; $i -lt $recent; $i++) {
        $at = $all[$i]
        "$($at.Id) $($at.Version)"
        $deployments = $repository.Deployments.FindMany({ param($r) $r.ReleaseId -eq $at.Id })
        foreach ($d in $deployments) {
            "`t$($d.Name) $($d.Created) $($d.Comments) $($d.Task)"
            $taskUrl = $d.Links['Task']
            $rt =  [Octopus.Client.Model.TaskResource]
            $task = [Getter]::Get($repository.Client, $taskUrl, $null, $rt ) 
            $color = [Console]::ForegroundColor
            if ($task.IsCompleted) {
                if ($task.FinishedSuccessfully) {
                    [Console]::ForegroundColor = "Green"
                } else {
                    [Console]::ForegroundColor = "Red"
                }
            } else {
                [Console]::ForegroundColor = "Yellow"
            }
            "`t`t$($task.Name) $($task.State) $($task.StartTime) $($task.Duration)"
            [Console]::ForegroundColor = $color
        }
    }
}