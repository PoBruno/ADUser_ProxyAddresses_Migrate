# Export All Users with ProxyAddresses to Migrate
# Bruno Gomes
#######

Import-Module ActiveDirectory
$Csvfile = "C:\Temp\All_ADUsers_ProxyAddresses.csv"

#Filter OU
$DNs = @(
    "DC=Company,DC=com,DC=br"
    #"OU=IT,OU=Users,OU=Company,DC=com,DC=brl",
    #"OU=Finance,OU=Users,OU=Company,DC=com"
)

$AllADUsers = @()
foreach ($DN in $DNs) {
    $Users = Get-ADUser -SearchBase $DN -Filter * -Properties * 
    $AllUsers += $Users}

$AllUsers = Get-ADUser -Filter * -Properties * | Sort-Object Name | Select-Object DisplayName,SamAccountName,UserPrincipalName,`
 @{L = "ProxyAddresses"; E = { ($_.ProxyAddresses -like 'smtp:*') -join ","}}
$AllUsers | Export-Csv -Encoding UTF8 -Path $Csvfile -NoTypeInformation -Delimiter ";"

#######
#Script complete
Write-Host "Script Execution - OK"
#
