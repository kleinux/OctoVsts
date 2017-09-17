. "$PSScriptRoot\Reset-VstsConnection.ps1"
function Test-Environment() {
    if ($MyInvocation.MyCommand.Module.PrivateData.buildDefinitions -eq $null) {
        Reset-VstsConnection
    }
}