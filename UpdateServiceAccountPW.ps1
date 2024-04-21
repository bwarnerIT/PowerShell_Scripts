########################################
# You will need to create a file named 'servers.txt'
# with a line-delimited list of servers to update.
########################################

$serviceAccount = "svcAccount" ## "DOMAIN\UserID"
$Password = "PASSWORD"
$Service = "SERVICE NAME"

foreach($server in Get-Content 'D:\Scripts\servers.txt') {
    $service = Get-WmiObject -Class Win32_Service -ComputerName $server -Filter "Name='$Service'"
    $StopStatus = $service.StopService()
    Write-Host "The service $service stopped on $server"

    ## Uncomment this if you will need to add the $serviceAccount to the local Administrators group
    # Invoke-Command -ComputerName $server -ScriptBlock {
    #     Add-LocalGroupMember -Group "Administrators" -Member $using:serviceAccount
    # } 

    if ($StopStatus.ReturnValue -eq 0) {
        Write-Host "The service $service stopped on $server"
    } else {
        Write-Host "The service $service failed to stop on $server"
    }

    $ChangeStatus = $service.Change($null, $null, $null, $null, $null, $null, "$serviceAccount", "$Password")

    if ($ChangeStatus.ReturnValue -eq 0) {
        Write-Host "Service Account ID and Password Updated on $server"
        start-sleep -s 30  ## Wait for the service to update.  You may need to adjust this time.
    } else {
        Write-Host "Service Account Failed to Update on $server"
    }

    $StartStatus = $service.StartService()

    if ($StartStatus.ReturnValue -eq 0) {
        Write-Host "The service $service started on $server"
    } else {
        Write-Host "The service $service failed to start on $server"
    }
}   