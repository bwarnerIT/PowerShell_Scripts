## Single threaded script to get installed applications on a text file list of remote computers

$computers = Get-Content 'D:\Scripts\servers.txt'

foreach ($computer in $computers) {
    $installedApps = @()

    $appKeys = @('HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall',
                'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall'
            )

    foreach ($appKey in $appKeys) {
        $uninstallKeys = Invoke-Command -ComputerName $computer -ScriptBlock {
            Get-ChildItem -Path $using:appKey | Get-ItemProperty | Where-Object { $_.DisplayName -and $_.UninstallString }
        } -ArgumentList $appKey

        foreach ($uninstallKey in $uninstallKeys) {
            $app = New-Object PSObject -Property @{
                ComputerName = $computer
                DisplayName = $uninstallKey.DisplayName
                DisplayVersion = $uninstallKey.DisplayVersion
                Publisher = $uninstallKey.Publisher
                InstallDate = $uninstallKey.InstallDate
                UninstallString = $uninstallKey.UninstallString
            }

            $installedApps += $app
        }
    
    $installedApps | Export-Csv -Path 'D:\Scripts\InstalledApps.csv' -NoTypeInformation
    }
}