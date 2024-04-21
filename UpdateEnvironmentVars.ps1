# This script will create a permanent System Environment Variable on a list of servers.  
# The script will need to be run as an Administrator.

$logfile = "D:\Scripts\UpdateEnvironmentVars.log"

Function Write-Log($logtext) {
    $logoutput = " " + (Get-Date -Format "yyyy-MM-dd HH:mm:ss") + " - " + $logtext
    $logoutput | Out-File -FilePath $logfile -Append
}

$servers = Get-Content 'D:\Scripts\servers.txt'

$var = "MYVAR"
$path = "D:\MyProgram\Scripts\app"

foreach ($server in $servers) {
    Write-Log "Checking to see if Environment Variable: $var exists on $server"
    $varExists = Invoke-Command -ComputerName $server -ScriptBlock {
        Test-Path env:$using:var
    }

    if ($varExists) {
        Write-Log "Environment Variable: $var exists on $server"
        
    } else {
        Write-Log "Environment Variable: $var does not exist on $server"
        Write-Log "Creating Environment Variable: $var on $server"
        Invoke-Command -ComputerName $server -ScriptBlock {
            [System.Environment]::SetEnvironmentVariable($using:var, $using:path, [System.EnvironmentVariableTarget]::Machine)
        }
        Write-Log "Environment Variable: $var created on $server"
    }
    
}