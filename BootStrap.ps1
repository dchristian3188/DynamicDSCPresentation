New-Item -Path C:\PS -ItemType Directory -ErrorAction SilentlyContinue

#Required Packages
Install-PackageProvider -Name Nuget -Force
Install-Module -Name xActiveDirectory, xComputerManagement, xNetWorking, xPSDesiredStateConfiguration, xWebAdministration, cChoco -Force

$AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
[System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols
Invoke-WebRequest -UseBasicParsing -Uri https://github.com/dchristian3188/DynamicDSCPresentation/archive/master.zip -OutFile C:\presentation.zip -Verbose
Expand-Archive -Path C:\presentation.zip -DestinationPath C:\
New-Item -Path C:\Github\ -ItemType Directory -Force -ErrorAction SilentlyContinue
Move-Item C:\DynamicDSCPresentation-master C:\github\DynamicDSCPresentation
