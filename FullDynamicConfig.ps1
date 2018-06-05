#Required Packages
Install-PackageProvider -Name Nuget -Force
Install-Module -Name xActiveDirectory, xComputerManagement, xNetWorking, xPSDesiredStateConfiguration, xWebAdministration, cChoco -Force

Configuration SampleConfig
{
    Import-DscResource -ModuleName xWebAdministration
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName xPSDesiredStateConfiguration
    Import-DscResource -ModuleName xNetworking
    Import-DscResource -ModuleName cChoco
    
    Node localhost
    {
        
        $WindowsFeatures = @(
            'Web-Server'
            'Web-Mgmt-Tools'
            'Web-Scripting-Tools'
            'NET-Framework-45-ASPNET'
            'Web-Asp-Net45'
        )

        ForEach ($feature in $WindowsFeatures)
        {
            WindowsFeature $feature
            {
                Name   = $feature
                Ensure = 'Present'
            }
        }


        cChocoInstaller InstallChoco
        {
            InstallDir = "c:\choco"
        }

        cChocoPackageInstaller urlrewrite
        {
            Name        = 'urlrewrite'
            AutoUpgrade = $true
            DependsOn   = '[cChocoInstaller]InstallChoco', '[WindowsFeature]Web-Server'
        }


        $Sites = @{
            Admin     = 8081
            WebPortal = 8082
            WebAPI    = 8083
        }

        foreach ($site in $sites.keys)
        {
            file "$($site)Root"
            {
                Type            = 'Directory'
                DestinationPath = "C:\LodaSoft\$($site)"
            }

            xWebAppPool "$($site)AppPool"
            {
                Name      = "$site"
                startMode = 'AlwaysRunning'
                State     = 'Started'
                DependsOn = '[WindowsFeature]Web-Server'
            }

            xWebsite "$($site)WebSite"
            {
                Name            = "$site"
                State           = 'Started'
                PhysicalPath    = "C:\LodaSoft\$($site)"
                ApplicationPool = "$site"
                BindingInfo     = MSFT_xWebBindingInformation
                {
                    Protocol = "HTTP"
                    Port     = $sites[$site]
                }
                DependsOn       = "[file]$($site)Root", "[xWebAppPool]$($site)AppPool"
            }
        }
        
        $firewallProfiles = @(
            'Domain',
            'Private',
            'Public'
        )

        Foreach ($firewallProfile in $firewallProfiles)
        {
            xFirewallProfile $firewallProfile
            {
                Name    = $firewallProfile
                Enabled = 'False'
            }
        }
    }
}

New-Item -Path C:\PS\SampleConfig -ItemType Directory -ErrorAction SilentlyContinue
SampleConfig -OutputPath C:\PS\SampleConfig\ -Verbose
Start-DSConfiguration -Force -Verbose -Wait -Path C:\PS\SampleConfig