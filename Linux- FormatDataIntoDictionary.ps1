$osArray = @()

#$filePath = Read-Host -Prompt "Enter the path for the CSV file: "

$csvFile = Import-Csv -Path "C:\Users\nlawson\OneDrive - Insight\Desktop\Linux\Device_Manager_Report-alex.higgins-20230224.csv" -WarningAction SilentlyContinue

ForEach ($object in $csvFile) {

    $osArrayObject = [PSCustomObject]@{
        DeviceName = "`"$($object."Device Name")`"" + ":"
        IPAddress  = "`"$($object."IP Address")`"" + ","
        OS         = ($object."Device Class | Sub-class").split(" ")[0]
        OSVersion  = (($object."Device Class | Sub-class") -split ("Linux \| "))[1]
    }

    $osArray += $osArrayObject

}

$osArray | Sort-Object -Property OSVersion
$osArray | Sort-Object -Property OSVersion | Select-Object DeviceName, IPAddress

$osArray | Sort-Object -Property OSVersion | Out-File -FilePath ".\FortmattedOSTypes.txt"

$osArray | Sort-Object -Property OSVersion | Select-Object DeviceName, IPAddress |  Out-File -FilePath ".\FortmattedDictionary.txt"