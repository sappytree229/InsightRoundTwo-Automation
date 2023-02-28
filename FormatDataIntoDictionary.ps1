$dictionaryArray = @()

$filePath = Read-Host -Prompt "Enter the path for the CSV file: "

$csvFile = Import-Csv -Path $filePath -WarningAction SilentlyContinue

$numberOfItems = ($csvFile).Count

$count = 0

ForEach ($object in $csvFile) {

    $count = $count + 1

    $device = [PSCustomObject]@{
        DeviceName = "`"$($object."Device Name")`""
        IPAddress  = "`"$($object."IP Address")`""
    }

    if ($count -lt ($numberOfItems)) {
        $dictionaryArray += $device.DeviceName + " : " + $device.IPAddress + ", "
    }

    else {
        $dictionaryArray += $device.DeviceName + " : " + $device.IPAddress
    }

}

$dictionaryArray | Out-File -FilePath ".\FortmattedDictionary.txt"