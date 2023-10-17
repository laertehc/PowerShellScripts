clear
$computers = ('')
$computers = Get-ADComputer -Filter * -SearchBase "Complete OU Path Ex: OU=IT_Computers,DC=mydomain,DC=local"|select Name
foreach($c in $computers){
    write-host $c.Name
    Invoke-Command -ComputerName $c.Name -ScriptBlock{
        Get-ChildItem -Path C:\ -Recurse -ErrorAction SilentlyContinue -Filter curl.exe | ForEach-Object {
            $Found = $($_.FullName)

            try {$version = & $_.FullName --version}
            catch {write-host "Failed to execute Version command of file $Found"
            write-host "---"}
            foreach($v in $version){
                $versions = ('')
                $version_number = ('')
                if($v -like '*curl*'){
                    $versions = $v.Split(" ")
                    $version_number = $versions[1].Split(".")
                    switch ($version_number[0]){
                        7 {
                            if($version_number[1] -ge 69) {
                                write-host "$Found is vulnerable to CVE-2023-38545" -ForegroundColor Green
                                write-host "Versão Curl: $versions[1]" -ForegroundColor Yellow
                                write-host "---"
                            }
                        }
                        8 {
                            if($version_number[2] -le 3) {
                                write-host "$Found is vulnerable to CVE-2023-38545" -ForegroundColor Green
                                write-host "Versão Curl: $versions[1]" -ForegroundColor Yellow
                                write-host "---"
                            }
                        }
                    }
                }
            }
        }
    }
}
