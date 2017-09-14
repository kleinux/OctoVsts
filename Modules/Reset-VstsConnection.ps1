

function Reset-VstsConnection() {
    $MyInvocation.MyCommand.Module.PrivateData.buildDefinitions = Get-VstsBuildDefinitions    
}