﻿#
# Module manifest for module 'OctoVsts'
#
# Generated by: Chris Klein
#
# Generated on: 2017-09-02
#

@{
    
    # Script module or binary module file associated with this manifest.
    RootModule = 'Loading.ps1'
    
    # Version number of this module.
    ModuleVersion = '1.0.2'
    
    # Supported PSEditions
    # CompatiblePSEditions = @()
    
    # ID used to uniquely identify this module
    GUID = 'f8782e00-d21b-4c0a-8a7f-a0c207e7144b'
    
    # Author of this module
    Author = 'Chris Klein'
    
    # Company or vendor of this module
    CompanyName = 'kleinux.com'
    
    # Copyright statement for this module
    Copyright = '(c) Chris Klein, All rights reserved.'
    
    # Description of the functionality provided by this module
    Description = 'Bridges the VSTS build functionality to the Octopus Deploy deployment functionality on the command line'
    
    # Minimum version of the Windows PowerShell engine required by this module
    # PowerShellVersion = ''
    
    # Name of the Windows PowerShell host required by this module
    # PowerShellHostName = ''
    
    # Minimum version of the Windows PowerShell host required by this module
    # PowerShellHostVersion = ''
    
    # Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # DotNetFrameworkVersion = ''
    
    # Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # CLRVersion = ''
    
    # Processor architecture (None, X86, Amd64) required by this module
    # ProcessorArchitecture = ''
    
    # Modules that must be imported into the global environment prior to importing this module
    # RequiredModules = @()
    
    # Assemblies that must be loaded prior to importing this module
    # RequiredAssemblies = @()
    
    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    # ScriptsToProcess = @()
    
    # Type files (.ps1xml) to be loaded when importing this module
    # TypesToProcess = @()
    
    # Format files (.ps1xml) to be loaded when importing this module
    # FormatsToProcess = @()
    
    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    NestedModules = @(
        'Classes/RestArgs.ps1',
        'Classes/VstsMetaData.ps1',
        'Modules/ConvertTo-VstsAuthorizationHeader.psm1'
        'Modules/Get-RestVsts.psm1',
        'Modules/Post-RestVsts.psm1',
        'Modules/Get-VstsBuildDefinitions.psm1',
        'Modules/Set-VstsConnection.psm1',
        'Modules/Get-VstsConnection.psm1',
        'Modules/Get-VstsRepositories.psm1',
        'Modules/Get-VstsRecentBuilds.psm1',
        'Modules/Wait-VstsBuild.psm1',
        'Modules/ConvertTo-VstsAuthorizationHeader.psm1',
        'Classes/Getter.psm1',
        'Modules/Get-OctoRepository.psm1',
        'Modules/Get-OctoReleases.psm1',
        'Modules/Set-OctoConnection.psm1',
        'Modules/Publish-OctoDeployment.psm1',
        'Modules/Wait-OctoDeployment.psm1',
        'Modules/Get-RestOcto.psm1',
        'Modules/Initialize-OctoVsts.psm1',
        'Modules/Initialize-OctoVstsDefaults.psm1',
        'Modules/Publish-Build.psm1',
        'Modules/New-PullRequest.psm1'
    )
    
    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport = @(
        'Set-VstsConnection',
        'Wait-VstsBuild',
        'Get-VstsRepositories',
        'Get-RestVsts',
        'Post-RestVsts'
        'Get-VstsConnection',
        'Get-VstsBuildDefinitions',
        'Get-VstsRecentBuilds',
        'ConvertTo-VstsAuthorizationHeader',
        'Get-OctoReleases',
        'Get-OctoRepository',
        'Set-OctoConnection',
        'Publish-OctoDeployment',
        'Wait-OctoDeployment',
        'Get-RestOcto',
        'Initialize-OctoVsts',
        'Initialize-OctoVstsDefaults',
        'Publish-Build',
        'New-PullRequest'
    )
    
    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport = @(
    )
    
    # Variables to export from this module
    VariablesToExport = '*'
    
    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport = @()
    
    # DSC resources to export from this module
    # DscResourcesToExport = @()
    
    # List of all modules packaged with this module
    # ModuleList = @()
    
    # List of all files packaged with this module
    # FileList = @()
    
    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData = @{
        buildDefinitions = $null
        PSData = @{
    
            # Tags applied to this module. These help with module discovery in online galleries.
            Tags = @('VSTS', 'Octopus-Deploy')
    
            # A URL to the license for this module.
            LicenseUri = 'https://choosealicense.com/licenses/mit/'
    
            # A URL to the main website for this project.
            ProjectUri = 'https://github.com/kleinux/OctoVsts'
    
            # A URL to an icon representing this module.
            # IconUri = ''
    
            # ReleaseNotes of this module
            # ReleaseNotes = ''
    
        } # End of PSData hashtable
    
    } # End of PrivateData hashtable
    
    # HelpInfo URI of this module
    # HelpInfoURI = ''
    
    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''
    
}
    