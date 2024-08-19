<#
.SYNOPSIS
console app for managing a group of computers in a ADFS domain.
BrEdPa 2024

.DESCRIPTION
Console application that was designed to stagger the rollout of an application to a hybrid cloud environment ended up being useful, so its functionality was expanded.
A .csv file can be made manually or otherwise exported from an OU/group you want to manage.
The app starts by asking if you need to delete computers from the domain (the most common activity), then if you want to move computers to a specific OU (second most common), and finally if you want to add them to a sec group (not that common).

.PARAMETER csvPath
full path for CSV, which needs the header "endpoints" for default. Advise using an unbroken string for the name/path, just makes things easier. Also, don't include quotation marks - if you use 'Copy As Path' make sure you get rid of 'em.

.EXAMPLE
Image a batch of laptops: Create the csv with the names of all the computers in your batch, then save the path. Run the app, selecting the first option. After the computers image and are in your New Computers OU, run the app again with the same CSV, but select the second option. 

.NOTES
This could be prettier, but it does get the job done - three jobs, actually. The 'joke' for the end of the script doesn't quite work as intended, as it can't capture anything special, but that's parsley on the plate afaic.
Easiest way to use this is by making a notepad file, creating the header and EXACT NAMES OF THE OBJECTS, then saving as a .csv instead of using Excel/Sheets. An example doc is available upon request.
Also make sure your paths/distinguished names are accurate past your OU, or otherwise modify as needed for the job.
#>

# Function to add endpoints present in AD to a specific SEC group
function addEndpointsToGroup {
    param (
        [string]$csvPath,
        [string]$targetGroup
    )
    # Read .csv & create an array to store valid rows
    $csvData = Import-CSV -Path $csvPath
    $targetEndpoints = @()

# forEach row, add to an array if it's present in AD
    forEach ($row in $csvData) {
        $endpoint = $row.endpoints
        # confirm endpoint's presence in AD
        IF (Get-ADComputer -Filter { Name -eq $endpoint }) {
            $targetEndpoints += $endpoint
            } 
        ELSE {
                Write-Output "Endpoint $endpoint not present in ADDS or not in the specified OU"
            }
    }
# forEach item in the array, add to group specified in $targetGroup
$executeFunction = Read-Host "Do you want to add" $targetEndpoints.count "objects to the desired group? (Y/N)"
    IF ($executeFunction -eq "Y" -or $executeFunction -eq "y") {
        forEach ($endpoint in $targetEndpoints) {
            $obj = Get-ADComputer $endpoint
            Add-ADGroupMember -ID $targetGroup -Members $obj
        }
    }
    ELSE {
        Write-Output "Operation cancelled; that was a close one!"
    }
}
function moveComputersToNewContainer {
    param (
        [string]$csvPath,
        [string]$TargetOU,
        [string]$distinguishedName
    )
    #read the file, make an array out of contents
    $csvData = Import-Csv -path $csvPath
    $targetEndpoints = @()

    # forEach row, add to an array if it's present in AD
    forEach ($row in $csvData) {
        $endpoint = $row.endpoints
        # confirm endpoint's presence in AD
        IF (Get-ADComputer -Filter { Name -eq $endpoint }) {
            $targetEndpoints += $endpoint
            } 
        ELSE {
                Write-Output "Endpoint $endpoint not present in ADDS or not in the specified OU"
            }
    }
    # forEach item in the array, add to distinguishedName of OU
    $executeFunction = Read-Host "Do you want to add" $targetEndpoints.count "objects to a new container? (Y/N)"
    IF ($executeFunction -eq "Y" -or $executeFunction -eq "y") {
        $targetOU = Read-Host "Enter the three character ID for the location of your target site's hybridJoin OU"
        $distinguishedName = "OU=HybridJoin,OU=Equipment,OU=OU $targetOU"#,OU=****,DC=****,DC=local"
        forEach ($endpoint in $targetEndpoints) {
            Get-ADComputer $endpoint | Move-ADObject -TargetPath $distinguishedName
        }
    }
    ELSE {
        Write-Output "Operation cancelled; that was a close one!"
    }
}
function removeComputersToImage {
    param (
        [string]$csvPath
    )
    #read the file, make an array out of contents
    $csvData = Import-Csv -path $csvPath
    $targetEndpoints = @()

    # forEach row, add to an array if it's present in AD
    forEach ($row in $csvData) {
        $endpoint = $row.endpoints
        # confirm endpoint's presence in AD
        IF (Get-ADComputer -Filter { Name -eq $endpoint }) {
            $targetEndpoints += $endpoint
            } 
        ELSE {
                Write-Output "Endpoint $endpoint not present in ADDS or not in the specified OU"
            }
    }
    # forEach item in the array, remove the object, with a count before doing so
    $executeFunction = Read-Host "Do you want to remove" $targetEndpoints.count "computers from the domain? (Y/N)"
    IF ($executeFunction -eq "Y" -or $executeFunction -eq "y") {
        forEach ($endpoint in $targetEndpoints) {
            Get-ADComputer $endpoint | Remove-adobject -recursive -Confirm:$false
        }
    }
    ELSE {
        Write-Output "Operation cancelled; that was a close one!"
    }
}

#greeting
Write-Host "Howdy! Let's manage some computers. Make sure your computers are in a csv file defined as Endpoints."
# Get variable file
$csvPath = Read-Host "Enter the full path for your .CSV file:"
#Follow the river; I need to add error catching if something goes wrong and write more specific instructions
$optionRemove = Read-Host "Do you want to delete computers you're getting ready to image? (Y/N)"
    IF ($optionRemove -eq "Y" -or $optionRemove -eq "y") {
        removeComputersToImage  -csvPath $csvPath
        Write-Host "All done - have a good one!"
        Exit 0
    }
    ELSEIF ($optionRemove -eq "N" -or $optionRemove -eq "n") {
        Write-Host "No computers to delete."
    }
$optionMove = Read-Host "Do you need to move some computers to a specific container? (Y/N)"
    IF ($optionMove -eq "Y" -or $optionMove -eq "y") {
        #$targetOU = Read-Host "Enter your target organizational unit:"
        moveComputersToNewContainer -csvPath $csvPath -TargetPath $distinguishedName
        write-host "All done - take it easy!"
        Exit 0
    }
    ELSEIF ($optionMove -eq "N" -or $optionMove -eq "n") {
        Write-Host "No computers to move."
    }
$optionAdd = Read-Host "Do you need to add some computers to a security group? (Y/N)"
    IF ($optionAdd -eq "Y" -or $optionAdd -eq "y") {
        $targetGroup = Read-Host "Enter the group you are adding these objects to."
        addEndpointsToGroup -csvPath $csvPath -targetGroup $targetGroup
        Write-Host "All done - see you later!"
        Exit 0
    }
    ELSEIF ($optionMove -eq "N" -or $optionMove -eq "n") {
        write-host "No computers to add..."
        $joke = Read-host "... well, what are you trying to do?"
        IF ($joke -eq "party" -or $joke -eq "*party*") {
            Write-Host "Hell yeah, go have fun."
            Exit 0
        }
        ELSE {
            Throw "Can't help you with that, friend. Go touch grass."
            Exit 1
        }
    }