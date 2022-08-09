# Import all ProxyAddresses bulk CSV file
# Bruno Gomes
#######

Import-Module ActiveDirectory

$PathFile = "C:\Temp\All_ADUsers_ProxyAddresses.csv"
$Users = Import-CSV $PathFile -Delimiter ";"

ForEach ($User in $Users){
    $SamAccountName = $User.SamAccountName
    $ProxyAddresses = $User.ProxyAddresses
    #$EmailAddress = $User.EmailAddress
    
    Set-ADUser $SamAccountName -add @{ProxyAddresses="$($ProxyAddresses)" -split ","}
    #Set-ADUser -Identity $SamAccountName -EmailAddress $EmailAddress
}

#######
#Script complete
Write-Host "Script Execution - OK"
#
