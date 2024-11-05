# Connect to SharePoint Online
$adminSiteUrl = "https://teops-admin.sharepoint.com/"
Connect-SPOService -Url $adminSiteUrl

# Get all site collections
$sites = Get-SPOSite -Limit All

# Create an array to hold results
$sharedLinks = @()

foreach ($site in $sites) {
    # Connect to the site
    Connect-PnPOnline -Url $site.Url -UseWebLogin

    # Get all document libraries
    $libraries = Get-PnPList | Where-Object { $_.BaseTemplate -eq 101 }

    foreach ($library in $libraries) {
        # Get shared items in the library
        $items = Get-PnPListItem -List $library

        foreach ($item in $items) {
            # Check if the item has any shared links
            $sharingInfo = Get-PnPSharingInformation -List $library -Identity $item.Id

            foreach ($link in $sharingInfo) {
                $sharedLinks += [PSCustomObject]@{
                    SiteUrl     = $site.Url
                    LibraryName = $library.Title
                    ItemName    = $item.FieldValues["FileLeafRef"]
                    SharedLink   = $link.Url
                    SharedBy    = $link.SharedBy
                    Expiration  = $link.Expiration
                }
            }
        }
    }

    # Disconnect from the site
    Disconnect-PnPOnline
}

# Export results to CSV
# $sharedLinks | Export-Csv -Path "c:\temp\SharedLinksReport.csv" -NoTypeInformation
$sharedLinks | Out-GridView

# Disconnect from SharePoint Online
Disconnect-SPOService
