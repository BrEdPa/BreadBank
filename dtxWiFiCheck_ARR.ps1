<#
WHO: BrEdPa
WHAT: PowerShell script to disable wireless network connections if a physical connection is active.
WHEN: August 2024
WHERE: LCHS
WHY: exam room equipment needs to only have a physical connection enabled; an open Wi-Fi connection can be exploited by attackers posing as patients. This script confirms that any exam room endpoints that have a Wi-Fi connection also have an ethernet connection so disabling the Wi-Fi will not fully disconnect the endpoint from the network.
HOW: Get all network adapters "named Ethernet" that are connected. If there is an ethernet connection, find any network adapter NOT "named Ethernet" and disable (confirming after doing so) then report compliance; if not, report that the only network connection the endpoint has is Wi-Fi so a Support rep can manually intervene.
#>

$EthernetCheck = (Get-NetAdapter -name 'Ethernet*').MediaConnectionState -eq 'Connected'

if ($EthernetCheck -eq $False){
    Throw 'No ethernet connection, manual intervention will be required.'
    Exit 1
}
else{
    (get-netAdapter).where({$psitem.name -notmatch 'ethernet'}) | disable-netAdapter -confirm:$false
    Write-Host 'Wi-Fi disconnected, exam room endpoint compliant.'
    exit 0
}