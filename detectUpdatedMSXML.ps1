##bredpa 2024 | AR Detect | checks for vuln. dll file that has been renamed to confirm deletion doesn't impact workflow on target devices.

#define variables
$path = "c:\windows\syswow64\msxml4.dll"
$checkPresencePath = Test-path -path $path
$pathUpdated = "c:\windows\syswow64\vuln_msxml4.dll"
$checkPresencePathUpdated = Test-path -path $pathUpdated

#check for bad file or updated file, exits if no vuln. detected
try{
    if (($checkPresencePath -eq $true) -or ($checkPresencePathUpdated -eq $true)) {
        throw "vulnerable/outdated DLL detected"
        }
    else {
        write-output "No vulnerable DLL file detected, device is secure."
        Exit 0
        }
}
catch{
    write-warning "Vulnerable DLL detected, proceed to deletion."
    Exit 1
}