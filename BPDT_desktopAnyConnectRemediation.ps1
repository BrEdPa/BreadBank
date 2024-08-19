##BrEdPa + Damian 2024 | uninstall script for AnyConnect specific to desktops

#define log file path
$logFile = "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs"
#define AnyConnect install media
$Path = "C:\Program Files (x86)\Cisco\Cisco AnyConnect Secure Mobility Client"
$presenceCheck = Test-path -path $path

#Function to log messages
function LogMessage {
    param(
        [string]$message,
        [string]$logFile
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp - $message"
    Add-Content -Path $logFile -Value $logEntry
}

#double check for Cisco AnyConnect
if ($presenceCheck -eq $true) {
	get-package -name "Cisco AnyConnect*" | uninstall-package -force
}
else {
    write-output "Cisco AnyConnect is not installed, device is compliant."
}