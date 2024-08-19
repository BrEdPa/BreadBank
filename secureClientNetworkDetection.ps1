#define config file location on network and destination on local machine
$sourceConfigFileRepositoryPath = "\\Repository\apps\Cisco Secure Client\configFileCopy\"
$configFileDestinationUmbrella = "C:\ProgramData\Cisco\Cisco Secure Client\Umbrella"
$configFileDestinationVPN = "C:\ProgramData\Cisco\Cisco Secure Client\VPN\Profile"

#define and store local machine variables for checking work
$configFileUmbrella = "C:\ProgramData\Cisco\Cisco Secure Client\Umbrella\OrgInfo.json"
$configFileVPN = "C:\ProgramData\Cisco\Cisco Secure Client\VPN\Profile\Anyconnect.xml"
$checkResultUmbrella = Test-Path -path $configFileUmbrella
$checkResultVPN = Test-Path -Path $configFileVPN

If ($checkResultUmbrella -eq $false -or $checkResultVPN -eq $false) {
#map network drive
    New-PSDrive -Name "Repository" -PSProvider FileSystem -Root $sourceConfigFileRepositoryPath
    Copy-Item -Path "Repository:\Anyconnect.xml" -Destination "C:\Scripts\" -Force
    Copy-Item -Path "Repository:\OrgInfo.json" -Destination $configFileDestinationUmbrella -Force
    #remove network drive
    Remove-PSDrive -Name "Repository" 
    Start-Sleep -Seconds 420
    Copy-Item -path "C:\Scripts\Anyconnect.xml" -Destination $configFileDestinationVPN
} 
else {
    Write-Output "Umbrella Configuration Present"
}
