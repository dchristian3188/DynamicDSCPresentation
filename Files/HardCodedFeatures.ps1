Configuration HardCodedFeatures
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Node localhost
    {
        WindowsFeature 'Web-Server'
        {
            Name   = 'Web-Server'
            Ensure = 'Present'
        }

        WindowsFeature 'Web-Mgmt-Tools'
        {
            Name   = 'Web-Mgmt-Tools'
            Ensure = 'Present'
        }

        WindowsFeature 'Web-Scripting-Tools'
        {
            Name   = 'Web-Scripting-Tools'
            Ensure = 'Present'
        }

        WindowsFeature 'NET-Framework-45-ASPNET'
        {
            Name   = 'NET-Framework-45-ASPNET'
            Ensure = 'Present'
        }

        WindowsFeature 'Web-Asp-Net45'
        {
            Name   = 'Web-Asp-Net45'
            Ensure = 'Present'
        }
    }
}

New-Item -Path C:\PS\HardCodedFeatures\ -ErrorAction SilentlyContinue
HardCodedFeatures -OutputPath C:\PS\HardCodedFeatures
Start-DscConfiguration -Verbose -Force -Wait -Path C:\PS\HardCodedFeatures