#Prompt User for the file of IPs
$IPAddressesFile = Read-Host -Prompt "Enter in the path for the file: "

Function ScanNetworkIPsAndPorts($IPAddressesFile) {    
    #Positve results array
    $PositiveResults = @()

    #Negative results array
    $NegativeResults = @()

    #Setting to not show progress bar of Test-NetConnection
    $Global:ProgressPreference = 'SilentlyContinue'
    
    #Variable to store the path of the passed file path
    $ImportedFile = Get-Content -LiteralPath $IPAddressesFile

    #List of comma separated ports
    $PortsList = @(5985)

    #Loop to iterate through each IP in the list
    ForEach ($IP in $ImportedFile) {

        #Reverse DNS lookup of IPs to find the domain name
        $ReverseDNS = Resolve-DnsName -Name $IP -ErrorAction SilentlyContinue -WarningAction SilentlyContinue

        #Output FQDN to the console
        Write-Host $ReverseDNS.NameHost

        #Loop to iterate through each port listed for each IP in the list
        ForEach ($Port in $PortsList) {   

            #Output the currently tested socket to the terminal
            Write-Host $IP : $Port
            #Test ports
            $test = Test-NetConnection `
                -ComputerName $IP `
                -Port $Port `
                -ErrorAction SilentlyContinue `
                -WarningAction SilentlyContinue `
                -InformationLevel Detailed
            #Add successful test to positive object
            if ($test.TcpTestSucceeded -eq $true) {

                $PositiveResult = [PSCustomObject]@{
                    ServerName = $ReverseDNS.NameHost
                    IPAddress  = $test.RemoteAddress
                    Port       = $test.RemotePort
                    Succeeded  = $test.TcpTestSucceeded
                }

                #Add successful object to positive results
                $PositiveResults += $PositiveResult
            }
            #Add un-successful test to negative object
            ElseIf ($test.TcpTestSucceeded -eq $false) {
                
                $NegativeResult = [PSCustomObject]@{
                    ServerName = $ReverseDNS.NameHost
                    IPAddress  = $test.RemoteAddress
                    Port       = $test.RemotePort
                    Succeeded  = $test.TcpTestSucceeded
                }

                #Add un-successful object to negative results
                $NegativeResults += $NegativeResult
            }
             
        }
   
    }
    #Add results together
    $TotalResults = $PositiveResults + $NegativeResults

    #Output results to text file
    Out-File -FilePath ".\ServerConnectionResults.txt" -InputObject $TotalResults

}
#Call function passing text file as parameter
ScanNetworkIPsAndPorts($IPAddressesFile)

#Exit program when automation is complete
Exit