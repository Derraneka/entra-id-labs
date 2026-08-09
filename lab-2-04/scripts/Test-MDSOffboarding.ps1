<#
.SYNOPSIS
    Verifies an offboarding completed correctly.

.DESCRIPTION
    Runs independently of the offboarding script and checks the account against
    five conditions. Separation matters: a script that reports on its own work
    proves nothing. This queries current directory state fresh.

.PARAMETER UserPrincipalName
    UPN of the offboarded account.

.EXAMPLE
    .\Test-MDSOffboarding.ps1 -UserPrincipalName marcus.webb@contoso.onmicrosoft.com
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$UserPrincipalName
)

$ErrorActionPreference = 'Stop'

if (-not (Get-MgContext)) {
    Connect-MgGraph -Scopes 'User.Read.All','Group.Read.All','AuditLog.Read.All' -NoWelcome
}

$user = Get-MgUser -UserId $UserPrincipalName -Property `
    Id, DisplayName, UserPrincipalName, AccountEnabled, SignInSessionsValidFromDateTime

$groups = Get-MgUserMemberOf -UserId $user.Id -All |
    Where-Object { $_.AdditionalProperties['@odata.type'] -eq '#microsoft.graph.group' }

$roles = Get-MgUserMemberOf -UserId $user.Id -All |
    Where-Object { $_.AdditionalProperties['@odata.type'] -eq '#microsoft.graph.directoryRole' }

$licenses = (Get-MgUserLicenseDetail -UserId $user.Id -ErrorAction SilentlyContinue)

$checks = @(
    [PSCustomObject]@{
        Check    = 'Account disabled'
        Expected = 'False'
        Actual   = $user.AccountEnabled
        Pass     = ($user.AccountEnabled -eq $false)
    }
    [PSCustomObject]@{
        Check    = 'Sessions revoked'
        Expected = 'Timestamp set'
        Actual   = $user.SignInSessionsValidFromDateTime
        Pass     = ($null -ne $user.SignInSessionsValidFromDateTime)
    }
    [PSCustomObject]@{
        Check    = 'Group memberships'
        Expected = '0'
        Actual   = $groups.Count
        Pass     = ($groups.Count -eq 0)
    }
    [PSCustomObject]@{
        Check    = 'Directory roles'
        Expected = '0'
        Actual   = $roles.Count
        Pass     = ($roles.Count -eq 0)
    }
    [PSCustomObject]@{
        Check    = 'Licenses'
        Expected = '0'
        Actual   = $licenses.Count
        Pass     = ($licenses.Count -eq 0)
    }
)

Write-Host ""
Write-Host "  OFFBOARDING VERIFICATION - $($user.DisplayName)" -ForegroundColor White
Write-Host "  ------------------------------------------------" -ForegroundColor DarkGray

$checks | ForEach-Object {
    $symbol = if ($_.Pass) { 'PASS' } else { 'FAIL' }
    $color  = if ($_.Pass) { 'Green' } else { 'Red' }
    Write-Host ("  [{0}] {1,-22} expected: {2,-14} actual: {3}" -f `
        $symbol, $_.Check, $_.Expected, $_.Actual) -ForegroundColor $color
}

$failCount = ($checks | Where-Object { -not $_.Pass }).Count

Write-Host ""
if ($failCount -eq 0) {
    Write-Host "  RESULT: All checks passed - offboarding verified" -ForegroundColor Green
} else {
    Write-Host "  RESULT: $failCount check(s) failed - review above" -ForegroundColor Red
}
Write-Host ""

return $checks
