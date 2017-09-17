. "$PSScriptRoot\Test-Environment.ps1"
<#
.SYNOPSIS
Gets the most recent builds for a build definition

.DESCRIPTION
Long description

.PARAMETER recent
How many builds to return at most. Defaults to 4

.PARAMETER sourceBranch
The branch that the build was invoked against. Defaults to the branch the call is made from, assuming this is invoked from a git repository. 
This is mandatory if not in a git repository

.EXAMPLE
Get-VstsRecentBuilds -recent 10 -sourceBranch develop -build VstsBuildDefinitionName

.NOTES
Outputs an object with properties:
 * Project - the project name
 * By - the display name of who invoked the build
 * Definition - the build definition name
 * BuildNumber - the build number property of the build
 * SourceBranch - the branch the build was invoked against
 * StartTime
 * FinishTime
 * Result - indicates if the build succeeded or not
#>
function Get-VstsRecentBuilds () { 
    [CmdletBinding(PositionalBinding = $false)]
    param(
        [Parameter(Mandatory = $false)]
        [int]$recent = 4,
        [Parameter(Mandatory = $false)]
        [string]$sourceBranch = $null
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
        $ParameterAttribute.Mandatory = $false
        $ParameterAttribute.Position = 0
        $AttributeCollection.Add($ParameterAttribute)

        # Add the attributes to the attributes collection

        # Generate and set the ValidateSet 
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($MyInvocation.MyCommand.Module.PrivateData.buildDefinitions.Keys)

        # Add the ValidateSet to the attributes collection
        $AttributeCollection.Add($ValidateSetAttribute)

        # Create and return the dynamic parameter
        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterName, [string], $AttributeCollection)
        $RuntimeParameterDictionary.Add($ParameterName, $RuntimeParameter)
        return $RuntimeParameterDictionary
        
    }
    begin {
        $build = $PSBoundParameters[$ParameterName]
        if ($build -ne $null -and $MyInvocation.MyCommand.Module.PrivateData.buildDefinitions.ContainsKey($build)) {
            $build = $MyInvocation.MyCommand.Module.PrivateData.buildDefinitions[$build]
        }
    }
    process {
        $response = Get-RestVsts -U "_apis/build/builds?definitions=$($build)&`$top=$($recent)" -V 2.0 -Verbose:$VerbosePreference
        foreach ($v in $response.value) {
            [pscustomobject] @{"Project" = $v.project.name; "By" = $v.requestedBy.displayName; Definition = $v.definition.name; BuildNumber = $v.buildNumber; SourceBranch = $v.sourceBranch; StartTime = $v.startTime; FinishTime = $v.finishTime; Result = $v.result} 
        }
    }
}