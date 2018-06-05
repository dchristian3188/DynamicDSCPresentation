New-Item -Path C:\PS -ItemType Directory -ErrorAction SilentlyContinue

#Required Packages
Install-PackageProvider -Name Nuget -Force
Install-Module -Name xActiveDirectory, xComputerManagement, xNetWorking, xPSDesiredStateConfiguration, xWebAdministration, cChoco -Force