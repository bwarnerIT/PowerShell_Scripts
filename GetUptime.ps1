# Check a text tile list of servers to see how long they've been up and the last time it has been rebooted

$LogFile = 'D:\Scripts\Uptime.log'
$Servers = Get-Content 'D:\Scripts\servers.txt'

Function Write-Log($logtext) {
    $logoutput = " " + (Get-Date -Format "yyyy-MM-dd HH:mm:ss") + " - " + $logtext
    $logoutput | Out-File -FilePath $LogFile -Append
}

foreach ($server in $Servers) {
    Write-Log "Checking uptime for $server"
    Try {
        $OS = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $server -ErrorAction Stop
        $uptime = (Get-Date) - $OS.ConvertToDateTime($OS.LastBootUpTime)
        $Properties = @{
            Server = $server
            LastBoot = $OS.ConvertToDateTime($OS.LastBootUpTime)
            Uptime = ([String]$uptime.Days + " days, " + $uptime.Hours + " hours, " + $uptime.Minutes + " minutes")
        }
        $Object = New-Object -TypeName PSObject -Property $Properties | Select ComputerName, LastBoot, Uptime

    } Catch {
        $ErrorMessage = "`n" + $server + " Error - " + $_.Exception.Message
        $ErroredServers += $ErrorMessage

        $Properties = @{
            Server = $server
            LastBoot = "Error"
            Uptime = "Error"
        }
        $Object = New-Object -TypeName PSObject -Property $Properties | Select ComputerName, LastBoot, Uptime
        Write-Log "Failed to get uptime for $server"
        Continue
    
    } Finally {
        Write-Output $Object
        Write-Log $Object

        $Object = $null
        $OS = $null
        $uptime = $null
        $ErrorMessage = $null
        $Properties = $null
    }
    
}

Write-Output ""
Write-Output "Servers that errored out:"
Write-Output $ErroredServers

Write-Log ""
Write-Log "Servers that errored out:"
Write-Log $ErroredServers