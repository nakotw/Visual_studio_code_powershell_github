# Get the date 180 days ago
$d = (get-date).AddDays(-879)
# Format the date in "yyyy-MM-ddTHH:mm:ssZ" format
$date =Get-Date $d -Format "yyyy-MM-ddTHH:mm:ssZ"  
# Get all devices that have not signed in since the specified date
$devices = get-mgdevice -filter "ApproximateLastSignInDateTime le $date" -all
$devices | Out-GridView
# Loop over each device
foreach ($device in $devices) {
    # Remove the device
    Remove-MgDeviceByDeviceId -deviceid $device.deviceid 
    echo $device.deviceid "has been deleted"
}