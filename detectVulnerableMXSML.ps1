$path = "c:\windows\syswow64\msxml4.dll"
$checkPresencePath = Test-path -path $path
$pathUpdated = "c:\windows\syswow64\vuln_msxml4.dll"
$checkPresencePathUpdated = Test-path -path $pathUpdated

try{
    if (($checkPresencePath -eq $true) -and ($checkPresencePathUpdated -eq $false)) {
        throw "vulnerable DLL detected"
        }
    else {
        write-output "No vulnerable DLL file detected."
        }
}
catch{
    write-warning "Vulnerable DLL detected, proceed to rename/uninstall."
    Exit 1
}