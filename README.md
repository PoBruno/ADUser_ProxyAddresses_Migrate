# Guide written by Bruno Gomes
# ActiveDirectory User ProxyAddresses Migrate
######

Export all users to CSV with ProxyAddresses.
Model initial script to report - [Get-ADUser_ProxyAddresses.ps1](https://github.com/lorthe/ADUser_ProxyAddresses_Migrate/blob/a765048562d01cd6cb60b67a094373f5aa57f181/Get-ADUser_ProxyAddresses.ps1)

> the report will have as delimiter ";" semicomma
```sh
$AllUsers | Export-Csv -Delimiter ";"
```
> The ProxyAddresses will be separated by "," comma
```sh
@{L = "ProxyAddresses"; E = { ($_.ProxyAddresses -like 'smtp:*') -join ","}}
```

> Separate all columns by ";" semicomma and in the ProxyAddresses column the SMPTs will be separated by "," comma

>for future steps, to insert the ProxyAddesses to set Powershell that the user information is separated by semicomma and in the ProxyAddresses column each SMTP is separated by a comma 
``` -add @{ProxyAddresses="$($ProxyAddresses)" -split ","} ```



- > NOTE : Complete script Adding ProxyAddresses 

```sh
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

```
# ActiveDirectory Import all User ProxyAddresses
Import all ProxyAddresses ADUsers bulk CSV file.
Model initial script to report - [Set-ADUser_ProxyAddresses_Migrate.ps1](https://github.com/lorthe/ADUser_ProxyAddresses_Migrate/blob/a765048562d01cd6cb60b67a094373f5aa57f181/Set-ADUser_ProxyAddresses_Migrate.ps1)

> Set local CSV file to Powershell import with ";" semicomma delimiter
```sh
$AllUsers | Export-Csv -Delimiter ";"
$Users = Import-CSV $PathFile -Delimiter ";"
```

> Create a loop for each line in the CSV file by adding ProxyAddresses stating that each is separated by "," comma
> ``` -add @{ProxyAddresses="$($ProxyAddresses)" -split ","} ```
```sh
 ForEach ($User in $Users){
    $SamAccountName = $User.SamAccountName
    $ProxyAddresses = $User.ProxyAddresses
    Set-ADUser $SamAccountName -add @{ProxyAddresses="$($ProxyAddresses)" -split ","}
}
```


- > NOTE : Complete script Adding ProxyAddresses 

```sh
Import-Module ActiveDirectory

$PathFile = "C:\Temp\All_ADUsers_ProxyAddresses.csv"
$Users = Import-CSV $PathFile -Delimiter ";"

 ForEach ($User in $Users){
    $SamAccountName = $User.SamAccountName
    $ProxyAddresses = $User.ProxyAddresses
    Set-ADUser $SamAccountName -add @{ProxyAddresses="$($ProxyAddresses)" -split ","}
}

```
