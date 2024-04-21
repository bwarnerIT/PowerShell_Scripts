$servers = Get-Content 'D:\Scripts\servers.txt'

$LogicalCPU = 0
$PhysicalCPU = 0

foreach ($server in $servers) {
    $Proc = [Object[]]$(Get-WmiObject Win32_Processor -ComputerName $server)
    $Core += $Proc.Count
    $LogicalCPU += $($Proc | Measure-Object NumberOfLogicalProcessors -Sum).Sum
    $PhysicalCPU += $($Proc | Measure-Object NumberOfCores -Sum).Sum

    $HT = @{
        LogicalCPU = $LogicalCPU
        PhysicalCPU = $PhysicalCPU
        CoreNr = $Core
        HypterThreading = $($LogicalCPU -gt $PhysicalCPU)

    }

    New-Object -TypeName PSObject -Property $HT
}

