

function Reset-VstsConnection() {
    $MyInvocation.MyCommand.Module.PrivateData.buildDefinitions = Get-VstsBuildDefinitions
    $MyInvocation.MyCommand.Module.PrivateData.users = $null
}