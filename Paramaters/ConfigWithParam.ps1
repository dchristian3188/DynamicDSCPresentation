Configuration ConfigWithParam
{
    Param
    (
        [String]
        $WebSiteName,

        [Int]
        $Port
    )
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName xWebAdministration
    Node localhost
    {
        file "$($WebSiteName)Root"
        {
            Type            = 'Directory'
            DestinationPath = "C:\MyApps\$($WebSiteName)"
        }

        xWebAppPool "$($WebSiteName)AppPool"
        {
            Name      = "$WebSiteName"
            startMode = 'AlwaysRunning'
            State     = 'Started'
        }

        xWebSite "$($WebSiteName)WebWebSiteName"
        {
            Name            = "$WebSiteName"
            State           = 'Started'
            PhysicalPath    = "C:\MyApps\$($WebSiteName)"
            ApplicationPool = "$WebSiteName"
            BindingInfo     = MSFT_xWebBindingInformation
            {
                Protocol = "HTTP"
                Port     = $Port
            }
            DependsOn       = "[file]$($WebSiteName)Root", "[xWebAppPool]$($WebSiteName)AppPool"
        }
    }
}

New-Item -Path C:\PS\ConfigWithParam\ -ErrorAction SilentlyContinue
ConfigWithParam -OutputPath C:\PS\ConfigWithParam -WebSiteName MySite1 -Port 9998
Start-DscConfiguration -Verbose -Force -Wait -Path C:\PS\ConfigWithParam

ConfigWithParam -OutputPath C:\PS\ConfigWithParam -WebSiteName MySite2 -Port 9997
Start-DscConfiguration -Verbose -Force -Wait -Path C:\PS\ConfigWithParam
