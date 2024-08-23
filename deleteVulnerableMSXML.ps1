##bredpa 2024 | AR Remediation | deletes vuln dll file after ~1 week monitoring devices where the dll in question was renamed

#begin transcript, define variables
Start-Transcript -path "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\deletemsxml4.txt" -IncludeInvocationHeader
$path = "c:\windows\syswow64\vuln_msxml4.dll"
$checkPresencePath = Test-path -path $path

#check for bad file; delete if present, else record no file
if ($checkPresencePath -eq $true) {
    write-warning "vulnerable DLL is present, deleting..."
    remove-item -path $path -Force
    write-output "file has been deleted"
}
else {
    write-output "No vulnerable DLL file detected, device is compliant."
}
Stop-Transcript