Configuration LoopingFireWalls
{
    Import-DscResource -ModuleName xNetworking
    Node localhost
    {

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

New-Item -Path C:\PS\LoopingFireWalls\ -ErrorAction SilentlyContinue
LoopingFireWalls -OutputPath C:\PS\LoopingFireWalls
Start-DscConfiguration -Verbose -Force -Wait -Path C:\PS\LoopingFireWalls