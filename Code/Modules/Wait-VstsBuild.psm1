. "$PSScriptRoot\Test-Environment.ps1"

<#
.SYNOPSIS
Pauses the script until the specified build is complete.

.DESCRIPTION
Pauses the script util the specified build is complete. If the build is in-progress then a progess bar is displayed. If the build failes then the reason is reported to the console.

.PARAMETER build
The name of the build definition to monitor.

.PARAMETER buildNumber
If specified then this build instance is checked, otherwise the latest build is monitored.

.PARAMETER pipeBuild
If specified then the build result is piped to output

.EXAMPLE
Wait-VstsBuild 'BuildDefinitionName' -buildNumber '201709.08.1-develop' -pipeBuild

#>
function Wait-VstsBuild () { 
    [CmdletBinding(PositionalBinding = $false)]
    param(
        [string]$buildNumber = $null,
        [switch]
        [bool]$pipeBuild = $false
    )
    DynamicParam {
        Test-Environment
        # Set the dynamic parameters' name
        $ParameterName = 'build'
        
        # Create the dictionary 
        $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

        # Create the collection of attributes
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        
        # Create and set the parameters' attributes
        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $true
        $ParameterAttribute.Position = 0
        $AttributeCollection.Add($ParameterAttribute)

        # Add the attributes to the attributes collection

        # Generate and set the ValidateSet 
        Write-Debug $MyInvocation.MyCommand.Module.PrivateData.buildDefinitions.Keys
        $ValidateSetAttribute = [System.Management.Automation.ValidateSetAttribute]::new($MyInvocation.MyCommand.Module.PrivateData.buildDefinitions.Keys)

        # Add the ValidateSet to the attributes collection
        $AttributeCollection.Add($ValidateSetAttribute)

        # Create and return the dynamic parameter
        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterName, [string], $AttributeCollection)
        $RuntimeParameterDictionary.Add($ParameterName, $RuntimeParameter)
        return $RuntimeParameterDictionary
        
    }
    begin {
        $build = $PSBoundParameters[$ParameterName]
        $definitionId = $MyInvocation.MyCommand.Module.PrivateData.buildDefinitions[$build]
    }
    process {
        # $v = Get-VstsConnection
        $urlBuild = "_apis/build/builds?definitions=$($definitionId)&`$top=1"
        if ($buildNumber -ne $null) {
            $urlBuild += "&buildNumber=$buildNumber"
        }
        $buildResponse = Get-RestVsts -U $urlBuild -V 2.0
        if ($buildResponse.Count -eq 0) {
            Write-Host "No builds found for $build"
            return
        }
        $latestBuild = $buildResponse.value[0];
        $buildId = $latestBuild.id
        $done = $false
        $activity = "Compiling $($latestBuild.buildNumber)"
        Write-Host $activity
        $currentOperation = "Starting"
        $timelineResponse = $null
        while (-not $done) {
            # $timelineResponse = Invoke-RestMethod -Method Get -Uri $urlTimeline -ContentType 'application/json' -Headers $v.RequestHeaders -Verbose:$VerbosePreference
            $timelineResponse = Get-RestVsts -U "_apis/build/builds/$buildId/timeline" -V 2.0
            $done = $true
            [float]$steps = $timelineResponse.records.Count
            [float]$completed = 0
            foreach ($record in $timelineResponse.records | Sort-Object order) {
                if ($record.state -eq "completed") {
                    $completed++
                }
                elseif ($record.state -eq "inProgress") {
                    $currentOperation = $record.name
                }
            }
            if ($steps -ne $completed) {
                Write-Progress -Activity $activity -PercentComplete ($completed / $steps * 100) -CurrentOperation $currentOperation
                $done = $false
                Start-Sleep -Seconds 1
            }
        }
        Write-Progress -Activity $activity -Completed
        "Build $($latestBuild.buildNumber) $($latestBuild.result)"
        if ($timelineResponse -ne $null) {
            foreach ($record in $timelineResponse.records) {
                if ($record.result -ne "succeeded") {
                    $record.name
                    foreach ($issue in $record.issues) { 
                        switch ($issue.type) {
                            "warning" { Write-Host "$($issue.type): $($issue.message)" -ForegroundColor Yellow }
                            "error" { Write-Host "$($issue.type): $($issue.message)" -ForegroundColor Red }
                            Default { Write-Host "$($issue.type): $($issue.message)"}
                        }
                        
                    }
                }
            }
        }
        if ($pipeBuild) {
            $buildResponse = Get-RestVsts -U $urlBuild -V 2.0
            $latestBuild = $buildResponse.value[0];        
            Write-Output $latestBuild  
        }      
    }
}