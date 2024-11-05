Write-Host ""
Write-Host "`tTool         :: Reset per-user multifactor authentication" -ForegroundColor Magenta
Write-Host "`tDescription  :: Reset per-user multifactor authentication to disabled for CAP use" -ForegroundColor Magenta
Write-Host "`tAuthor       :: Florian Daminato" -ForegroundColor Magenta
Write-Host "`tCompany      :: FDCORP" -ForegroundColor Magenta
Write-Host ""

# Connect to tenant
Connect-MsolService

# Sets the MFA requirement state
function Set-MfaState {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName = $True)]
        $ObjectId,
        [Parameter(ValueFromPipelineByPropertyName = $True)]
        $UserPrincipalName,
        [ValidateSet("Disabled", "Enabled", "Enforced")]
        $State
    )
    Process {
        Write-Verbose ("Setting MFA state for user '{0}' to '{1}'." -f $ObjectId, $State)
        $Requirements = @()
        if ($State -ne "Disabled") {
            $Requirement =
            [Microsoft.Online.Administration.StrongAuthenticationRequirement]::new()
            $Requirement.RelyingParty = "*"
            $Requirement.State = $State
            $Requirements += $Requirement
        }
        Set-MsolUser -ObjectId $ObjectId -UserPrincipalName $UserPrincipalName `
            -StrongAuthenticationRequirements $Requirements
    }
}
# Disable MFA for all users
Get-MsolUser -All | Set-MfaState -State Disabled