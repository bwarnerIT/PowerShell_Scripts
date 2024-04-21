# This script will get the total size of the $folderPath and the sizes of each folder inside $folderPath - just one level.
# Can work on any machine - just change the $folderPath and $outputFile variables.

$folderPath = "C:\Program Files"
$outputFile = "D:\Scripts\FolderSizes.csv"

# Get the $MainFolderSize

$MainFolderSize = (Get-ChildItem -Path $folderPath -Recurse -File | Measure-Object -Property Length -Sum).Sum / 1GB
$formattedMainFolderSize = "{0:N2}" -f $MainFolderSize
$today = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Write-Host "$today - Size of $folderPath : $($formattedMainFolderSize) GB"
"Size of $folderPath : $($formattedMainFolderSize) GB" | Out-File -FilePath $outputFile -Append

# Get the sizes of each folder inside $folderPath
$subFolders = Get-ChildItem -Path $folderPath -Directory

foreach ($subFolder in $subFolders) {
    $subFolderSize = (Get-ChildItem -Path $subFolder.FullName -Recurse -File | Measure-Object -Property Length -Sum).Sum / 1GB
    $formattedSubFolderSize = "{0:N2}" -f $subFolderSize
    Write-Host "$today - Size of $($subFolder.FullName) : $($formattedSubFolderSize) GB"
    "Size of $($subFolder.FullName) : $($formattedSubFolderSize) GB" | Out-File -FilePath $outputFile -Append
}