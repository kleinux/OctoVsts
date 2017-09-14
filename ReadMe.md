# Octo-VSTS 
A command line bridge between VSTS builds to Octopus deployments
## Installation
```Powershell
PS> Install-Module OctoVsts
PS> Initialize-OctoVsts -VstsInstance <string> -VstsProject <string> -VstsAccessToken <string> -OctoApiKey <string> -OctoUri <uri>
```
Input descriptions for Initialize-OctoVsts:
* VstsInstance: The instance component of your VSTS server found as https://{instance}.visualstudio.com/ 
* VstsProject: The project your code resides within in VSTS. Can be found in the VSTS server url as https://{instance}.visualstudio.com/{project}/
* VstsAccessToken: You will need to login to your VSTS server and generate this. [Documentation](https://www.visualstudio.com/en-us/docs/setup-admin/team-services/use-personal-access-tokens-to-authenticate)
* OctoApiKey: You will need to login to your Octopus server and generate this. [Documentation](https://github.com/OctopusDeploy/OctopusDeploy-Api/wiki/Authentication)
* OctoUri: The server name of the Octopus server with an https protocol

Generate a OctoVsts.json file in the root of your repository. 
```Powershell
PS> Initialize-OctoVstsDefaults -VstsBuildDefinition <string> -OctoDefaultEnvironment <string>
```
Input descriptions for Initialize-OctoVstsDefaults:
* VstsBuildDefinition: The name of the build in VSTS associated with this repository. If there is more than one build definition for the repository use the one more convenient here.
* OctoDefaultEnvironment: The name of the environment that Octopus will deploy to by default.

## How to use
* Publish-Build - Checks VSTS for the latest build in the current build definition and git branch. Waits for the build to complete. If successful will then deploy that build in Octopus to the current environment.
** Environment: Overrides OctoDefaultEnvironment
** SourceBranch: Overrides the source branch of the build to check. The default here is the current git repository that publish is executing in.
** Force: Skips the confirmation before deploying build in Octopus