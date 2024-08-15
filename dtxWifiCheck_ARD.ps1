<#
WHO: BrEdPa
WHAT: PowerShell script to detect if an endpoint has a wireless connection disabled
WHEN: August 2024
WHERE: ****
WHY: **** equipment needs to only have a physical connection enabled; an open Wi-Fi connection can be exploited by attackers ****. 
    This script confirms if all non-ethernet connections are disabled for endpoints in ****.
HOW: Get all network adapters, check for an adapter "named Wi-Fi" and if it is disconnected. If yes, report compliance; if no, proceed with remediation.
#>

$WiFiCheck = ((get-netAdapter).where({$psitem.name -Match 'Wi-Fi'}).status -eq 'disabled')

if ($WiFiCheck -eq $true){
    Write-Host 'Wi-Fi is disabled, device is compliant.'
    Exit 0
}
else {
    Write-Warning 'Wi-Fi is enabled, proceed with remediation.'
    Exit 1
}