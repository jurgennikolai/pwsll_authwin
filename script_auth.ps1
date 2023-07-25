﻿$pathDirectory = '<insert path>'

$pathReport = "$pathDirectory\report.csv"
$hostnames = Get-Content  "$pathDirectory\hostnames.txt"

$credential = Get-Credential

#Format CSV: Hostname, Conn. Puerto, Conn. Credenciales, Observacion
Add-Content -Path $pathReport -Value "Hostname,Conn. Puerto,Conn. Credenciales,Observacion" #Cabecera CSV

foreach ($hostname in $hostnames)
{
    $hasPortConnection = Test-NetConnection -Port 3389 -ComputerName $hostname

    if($hasPortConnection.TcpTestSucceeded){
        [bool] $hasError = 0 # 0 => False | 1 => True  

        $result = Invoke-Command -ComputerName $hostname -Credential $credential -ScriptBlock {
            try{
                $true
            }catch{
                return $false
            }
        }
        if($resul){
            Add-Content -Path $pathReport -Value "$hostname, True, True, Access Successful ."
        }else{
            Add-Content -Path $pathReport -Value "$hostname, True, False, DMZ o Incorrect Credentials."
        }

    }else {
        Add-Content -Path $pathReport -Value "$hostname, False, False, No Arrival at Port 3389(RDP). "
    }
}