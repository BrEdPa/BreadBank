##BrEdPa 2024 | Script to address secVuln caused by an outdated DLL file related to MSXML, deployed via Intune to workstations
#! file = msxml4.dll
#! file path = c:\windows\syswow64\msxml4.dll
#! create check logic for msxml6
$timestamp = get-date -format o | forEach-object { $_ -replace ":", "."}
#$pathTimestamp = "C:\scripts\"
$path = "c:\windows\syswow64\msxml4.dll"
$checkPresencePath = Test-path -path $path

    if ($checkPresencePath -eq $true) {
        write-warning "vulnerable DLL is present, renaming"
        rename-item -path $path -NewName "vuln_msxml4.dll"
        new-item -path "C:\scripts\$timestamp" -type File
        write-output "file renamed, timestamp created"
        Exit 0
    }
    else {
        write-output "No vulnerable DLL file detected, checking for change."
        Exit 1
    }


   #< test-path -path "C:\windows\SysWOW64\vuln_msxml4.dll" -NewerThan
    #if ($true){
     #   remove-item -path "C:\windows\SysWOW64\vuln_msxml4.dll"
      #  write-output "file deleted, vulnerability remediated"
       # exit 0
    #}
    #else {
     #   write-output "file not present, "
    #}
    #>