# Set Mailbox Language and timezone
$language = "en-US"
$timezone = "Eastern Standard Time"

## Set Time and language on all mailboxes to Set Timezone and English-USA
Write-Host -ForegroundColor $AssessmentColor "Configuring Date/Time and Locale settings for each mailbox"
Write-Host -ForegroundColor $MessageColor "The script may hang at this step for a while. Do not interrupt or close it."


Get-Mailbox -ResultSize unlimited | ForEach-Object {
    Set-MailboxRegionalConfiguration -Identity $PsItem.alias -Language $language -TimeZone $timezone
}
            
Write-Host
Write-Host -ForegroundColor $MessageColor "Time, Date and Locale configured for each mailbox"