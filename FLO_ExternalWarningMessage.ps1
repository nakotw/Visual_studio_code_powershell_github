# Connect to Exchange Online
Write-Host "Connect to Exchange Online" -ForegroundColor Cyan
Connect-ExchangeOnline

$HTMLDisclaimer = '<table border=0 cellspacing=0 cellpadding=0 align="left" width="100%">
  <tr>
    <td style="background:#ffb900;padding:5pt 2pt 5pt 2pt"></td>
    <td width="100%" cellpadding="7px 6px 7px 15px" style="background:#fff8e5;padding:5pt 4pt 5pt 12pt;word-wrap:break-word">
      <div style="color:#222222;">
        <span style="color:#222; font-weight:bold;">Attention :</span>
        Ce courriel provient de l’extérieur de ITI. Si vous avez un doute sur certains éléments, veuillez contacter votre service TI!
      </div>
    </td>
  </tr>
</table>
<br/>'


Write-Host "Creating Transport Rule" -ForegroundColor Cyan

# Create new Transport Rule
New-TransportRule -Name "Alerte message externe" `
                  -FromScope NotInOrganization `
                  -SentToScope InOrganization `
                  -ApplyHtmlDisclaimerLocation Prepend `
                  -ApplyHtmlDisclaimerText $HTMLDisclaimer `
                  -ApplyHtmlDisclaimerFallbackAction Wrap

Write-Host "Transport rule created" -ForegroundColor Green