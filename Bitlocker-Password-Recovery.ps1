clear
$computer = @('')
$computer = get-adcomputer -filter *|Sort-Object name
$computerl = ''
$Bitlocker = @()
foreach($c in $computer){
    $ad = Get-ADObject -Filter {ObjectClass -eq 'msFVE-RecoveryInformation'} -SearchBase $c.DistinguishedName -Properties "msFVE-RecoveryPassword", whencreated
    #if($ad.Length -eq 0){write-host $c.Name -ForegroundColor red}
    #else{ 
        foreach($a in $ad){
            $computername =  $c.Name
            $password = $a."msFVE-RecoveryPassword"
            $createddate = $a.whencreated
            $Bitlocker+=[PSCustomObject]@{
                ComputerName = $computername
                PasswordRecovery  = $password
                CreatedDate       = $createddate
            }
            
        }
    #}
    
}
$Bitlocker|export-csv "C:\Report\BitlockerRecovery.csv" -NoTypeInformation
