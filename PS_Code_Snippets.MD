## Powershell Code Snippets

Here are some handy Powershell scripts I've used from time to time:

### Get-Process
The below command can be ran on a server to see the Process IDs, Path with service session ID, and how much memory the process is using (in bytes)

```Powershell
Get-Process -Name Code | Select Name, ID, Path, ws
```

Result:
```
Name    Id Path                                                                         WS
----    -- ----                                                                         --
Code  1740 C:\Users\My User\AppData\Local\Programs\Microsoft VS Code\Code.exe  90935296
Code  6572 C:\Users\My User\AppData\Local\Programs\Microsoft VS Code\Code.exe 136491008
Code 13408 C:\Users\My User\AppData\Local\Programs\Microsoft VS Code\Code.exe  91725824
Code 13544 C:\Users\My User\AppData\Local\Programs\Microsoft VS Code\Code.exe  97468416
Code 14016 C:\Users\My User\AppData\Local\Programs\Microsoft VS Code\Code.exe  42635264
Code 18160 C:\Users\My User\AppData\Local\Programs\Microsoft VS Code\Code.exe  85864448

```

### Basic Logging Function

```Powershell
$Logfile = "<path-to-logfile>"

Function Write-Log($logtext) {
    $logoutput = " " + $(Get-Date) + " ... " + $logtext
    $logoutput | Out-File -Encoding ascii $logfile -append
}
```
Examples of usage:

```Powershell
Write-Log "This environment Varialbe is already set."
...
Write-Log "$server was updated with the new variable."
...
$Object = New-Object -TypeName PSObject -Property $properties | Select ComputerName, LastBoot, Uptime
Write-Log $Object
```

### Setting the time-zone on a server

```Powershell
& $env:windir\system32\tzutil /s "Eastern Standard Time"
```

### Get Active Directory Group Members

```Powershell
Get-ADGroupMember -Identity 'MyGroupName' | Select-Object name
```