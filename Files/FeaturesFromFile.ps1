Configuration FeaturesFromFile
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Node localhost
    {
        $WindowsFeatures = Get-Content -Path 'C:\github\DynamicDSCPresentation\Files\Features.txt'

        ForEach ($feature in $WindowsFeatures)
        {
            WindowsFeature $feature
            {
                Name   = $feature
                Ensure = 'Present'
            }
        }
    }
}

New-Item -Path C:\PS\FeaturesFromFile\ -ErrorAction SilentlyContinue
FeaturesFromFile -OutputPath C:\PS\FeaturesFromFile
Start-DscConfiguration -Verbose -Force -Wait -Path C:\PS\FeaturesFromFile