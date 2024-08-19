##BrEdPa + Damian 2024 | detection script for AnyConnect uninstall specific to desktops

#define variables for Cisco AnyConnect install files
$Path = "C:\Program Files (x86)\Cisco\Cisco AnyConnect Secure Mobility Client"
$presenceCheck = Test-path -path $path

Try {
        if ($presenceCheck -eq $true){
        Write-Warning "AnyConnect is present, device noncompliant."
        exit 1
        }
        else {
            Write-Output "AnyConnect is not present, device compliant."
            Exit 0
        }
    }
Catch {
        Write-Warning "AnyConnect is installed, proceed to uninstall."
        Exit 1
}