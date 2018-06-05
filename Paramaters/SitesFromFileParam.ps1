Configuration SitesFromFileParam
{
    Param
    (
        [string]
        $SiteFile
    )
    Import-DscResource -ModuleName xWebAdministration
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    if (-not(Test-Path -Path $siteFile))
    {
        Throw "Unable to Find file at path [$SiteFile]"
    }

    Node localhost
    {
        $WebSites = Import-CSV -Path $SiteFile
        foreach ($site in $WebSites)
        {
            file "$($site.WebSiteName)Root"
            {
                Type            = 'Directory'
                DestinationPath = "C:\MyApps\$($site.WebSiteName)"
            }
    
            xWebAppPool "$($site.WebSiteName)AppPool"
            {
                Name      = "$($site.WebSiteName)"
                startMode = 'AlwaysRunning'
                State     = 'Started'
            }
    
            xWebSite "$($site.WebSiteName)WebWebSiteName"
            {
                Name            = "$($site.WebSiteName)"
                State           = 'Started'
                PhysicalPath    = "C:\MyApps\$($site.WebSiteName)"
                ApplicationPool = "$($site.WebSiteName)"
                BindingInfo     = MSFT_xWebBindingInformation
                {
                    Protocol = "HTTP"
                    Port     = $($site.Port)
                }
                DependsOn       = "[file]$($site.WebSiteName)Root", "[xWebAppPool]$($site.WebSiteName)AppPool"
            }
        }
    }
}

New-Item -Path C:\PS\SitesFromFileParam\ -ErrorAction SilentlyContinue
#SitesFromFileParam -OutputPath C:\PS\SitesFromFileParam -SiteFile 'fakefilePath.txt'

SitesFromFileParam -OutputPath C:\PS\SitesFromFileParam -SiteFile 'C:\github\DynamicDSCPresentation\Paramaters\WebSites.csv'
Start-DscConfiguration -Verbose -Force -Wait -Path C:\PS\SitesFromFileParam
