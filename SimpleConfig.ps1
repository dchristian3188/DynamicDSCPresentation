configuration SimpleConfig
{
   Import-DscResource -ModuleName PSDesiredStateConfiguration
    node localhost
    {
        file myDirectory
        {
            Type = 'File'
            DestinationPath = 'C:\SoCalPosh.txt'
            Contents = 'Hi From SoCal Posh'
        }    
    }
}

New-Item -Path C:\PS\SimpleConfig\ -ErrorAction SilentlyContinue
SimpleConfig -OutputPath C:\PS\SimpleConfig
Code C:\PS\SimpleConfig\localhost.mof