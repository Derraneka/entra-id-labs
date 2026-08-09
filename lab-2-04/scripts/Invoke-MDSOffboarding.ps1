<#
.SYNOPSIS
    Automated emergency offboarding for Microsoft Entra ID.
.DESCRIPTION
    Revokes sessions FIRST, then disables, then strips groups - closing the
    exposure window that manual portal offboarding leaves open (measured at
    2m41s in Lab 2.1). Writes a JSON evidence artifact.
.EXAMPLE
    .\Invoke-MDSOffboarding.ps1 -UserPrincipalName test@contoso.com -TicketNumber MDS-1301 -WhatIf
.NOTES
    Author: Derra Hewlett | Lab 2.4 - Offboarding Automation
    Scopes: User.ReadWrite.All, Group.ReadWrite.All, Directory.ReadWrite.All
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string]$UserPrincipalName,
    [Parameter(Mandatory)][string]$TicketNumber,
    [string]$OutputPath = ".\offboarding-evidence"
)

$ErrorActionPreference = 'Stop'
$start = Get-Date

function Say($msg, $c = 'Cyan') {
    Write-Host "[$((Get-Date).ToString('HH:mm:ss.fff'))] " -NoNewline -ForegroundColor DarkGray
    Write-Host $msg -ForegroundColor $c
}

$ctx = Get-MgContext
if (-not $ctx) { throw "Not connected. Run Connect-MgGraph first." }

Write-Host "`n  MDS EMERGENCY OFFBOARDING" -ForegroundColor White
Write-Host "  Target : $UserPrincipalName"
Write-Host "  Ticket : $TicketNumber"
Write-Host "  Mode   : $(if ($WhatIfPreference) { 'WHAT-IF' } else { 'LIVE' })`n" -ForegroundColor $(if ($WhatIfPreference) { 'Yellow' } else { 'Red' })

# STEP 1 - Baseline. Without this, removals can't be verified as complete.
Say "STEP 1 - Baseline access"
$user = Get-MgUser -UserId $UserPrincipalName -Property Id,DisplayName,UserPrincipalName,AccountEnabled,Department,JobTitle

$memberOf = Get-MgUserMemberOf -UserId $user.Id -All
$groups = $memberOf | Where-Object { $_.AdditionalProperties['@odata.type'] -eq '#microsoft.graph.group' } | ForEach-Object {
    [PSCustomObject]@{
        GroupId = $_.Id
        Name    = $_.AdditionalProperties['displayName']
        Type    = if ($_.AdditionalProperties['membershipRule']) { 'Dynamic' } else { 'Assigned' }
    }
}
$roles = $memberOf | Where-Object { $_.AdditionalProperties['@odata.type'] -eq '#microsoft.graph.directoryRole' } |
    ForEach-Object { $_.AdditionalProperties['displayName'] }

Say "  $($user.DisplayName) | Enabled: $($user.AccountEnabled) | Groups: $($groups.Count)" 'Green'
$groups | ForEach-Object { Say "      - $($_.Name) [$($_.Type)]" }
if ($roles) { Say "  Directory roles: $($roles -join ', ')" 'Yellow' }

$assigned = @($groups | Where-Object Type -eq 'Assigned')
$dynamic  = @($groups | Where-Object Type -eq 'Dynamic')

# STEP 2 - Revoke FIRST. Disabling alone leaves refresh tokens valid.
Say "STEP 2 - Revoke all sessions"
$revoked = $null
if ($PSCmdlet.ShouldProcess($UserPrincipalName, "Revoke refresh tokens")) {
    # Direct Graph API call. The SDK cmdlet name has changed across versions;
    # the REST endpoint has not. See lab README, "The SDK is not the API".
    Invoke-MgGraphRequest -Method POST -Uri "https://graph.microsoft.com/v1.0/users/$($user.Id)/revokeSignInSessions" | Out-Null
    $revoked = Get-Date
    Say "  Tokens invalidated - all sessions terminated" 'Green'
} else { Say "  [WhatIf] Would revoke all tokens" 'Yellow' }

# STEP 3 - Disable. Establishes the containment timestamp.
Say "STEP 3 - Disable account"
$disabled = $null
if ($PSCmdlet.ShouldProcess($UserPrincipalName, "Set AccountEnabled = false")) {
    Update-MgUser -UserId $user.Id -AccountEnabled:$false
    $disabled = Get-Date
    Say "  AccountEnabled = false" 'Green'
} else { Say "  [WhatIf] Would disable account" 'Yellow' }

$window = if ($revoked -and $disabled) { [math]::Round(($disabled - $revoked).TotalSeconds, 3) } else { $null }
if ($null -ne $window) { Say "  Exposure window: ${window}s" 'Green' }

# STEP 4 - Strip assigned groups. Dynamic groups resolve on their own.
Say "STEP 4 - Remove group memberships"
$removed = @(); $failed = @()
foreach ($g in $assigned) {
    if ($PSCmdlet.ShouldProcess($g.Name, "Remove member")) {
        try {
            Remove-MgGroupMemberByRef -GroupId $g.GroupId -DirectoryObjectId $user.Id
            $removed += $g; Say "  Removed from $($g.Name)" 'Green'
        } catch {
            $failed += [PSCustomObject]@{ Group = $g.Name; Error = $_.Exception.Message }
            Say "  FAILED: $($g.Name) - $($_.Exception.Message)" 'Red'
        }
    } else { Say "  [WhatIf] Would remove from $($g.Name)" 'Yellow' }
}
$dynamic | ForEach-Object { Say "  Skipped $($_.Name) - dynamic, resolves on attribute change" 'Yellow' }

# STEP 5 - Evidence for the personnel file.
Say "STEP 5 - Write evidence"
if (-not (Test-Path $OutputPath)) { New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null }

$evidence = [PSCustomObject]@{
    TicketNumber          = $TicketNumber
    ExecutedBy            = $ctx.Account
    ExecutedUtc           = $start.ToUniversalTime().ToString('o')
    TenantId              = $ctx.TenantId
    WhatIfMode            = [bool]$WhatIfPreference
    User                  = $user.UserPrincipalName
    UserObjectId          = $user.Id
    BaselineEnabled       = $user.AccountEnabled
    BaselineGroups        = $groups
    BaselineRoles         = $roles
    SessionsRevokedUtc    = if ($revoked)  { $revoked.ToUniversalTime().ToString('o') }  else { $null }
    AccountDisabledUtc    = if ($disabled) { $disabled.ToUniversalTime().ToString('o') } else { $null }
    ExposureWindowSeconds = $window
    GroupsRemoved         = $removed
    GroupsSkippedDynamic  = $dynamic
    Failures              = $failed
    RuntimeSeconds        = [math]::Round(((Get-Date) - $start).TotalSeconds, 3)
}

$safe = $user.UserPrincipalName -replace '[^\w\.\-]', '_'
$file = Join-Path $OutputPath "offboarding-$safe-$(Get-Date -f 'yyyyMMdd-HHmmss').json"
$evidence | ConvertTo-Json -Depth 6 | Out-File $file -Encoding UTF8
Say "  $file" 'Green'

Write-Host "`n  SUMMARY" -ForegroundColor White
Write-Host "  Baseline groups : $($groups.Count)"
Write-Host "  Removed         : $($removed.Count)"
Write-Host "  Dynamic (auto)  : $($dynamic.Count)"
Write-Host "  Failures        : $($failed.Count)" -ForegroundColor $(if ($failed.Count) { 'Red' } else { 'Green' })
if ($null -ne $window) { Write-Host "  Exposure window : ${window}s" -ForegroundColor Green }
Write-Host "  Runtime         : $($evidence.RuntimeSeconds)s`n"

if ($failed.Count) { Say "Completed with errors" 'Red' } else { Say "Offboarding complete" 'Green' }
