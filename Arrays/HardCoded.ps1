Configuration HardCodedFireWalls
{
    Import-DscResource -ModuleName xNetworking
    Node localhost
    {

        xFirewallProfile Domain
        {
            Name = 'Domain'
            Enabled = 'False'
        }

        xFirewallProfile Private
        {
            Name = 'Private'
            Enabled = 'False'
        }

        xFirewallProfile Public
        {
            Name = 'Public'
            Enabled = 'False'
        }
    }
}

New-Item -Path C:\PS\HardCodedFireWalls\ -ErrorAction SilentlyContinue
HardCodedFireWalls -OutputPath C:\PS\HardCodedFireWalls
Start-DscConfiguration -Verbose -Force -Wait -Path C:\PS\HardCodedFireWalls