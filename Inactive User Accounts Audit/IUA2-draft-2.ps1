# Inactive User Accounts Check Script
# Version 2.0

# This PowerShell script goes through Users in the domains Active Directory
# and finds all users that have been inactive for more than X days.

#region 1. AD Module

# We start off by adding the AD module
# We will be adding Error Handling that will display if the module is not installed or the User has insufficient permissions
try{
    Import-Module ActiveDirectory -ErrorAction Stop
}
catch {
    Write-Error "Active Directory module could not be loaded. `nVerify that the module is installed and that you have sufficient permissions. Exiting Script."
    exit
}
#endregion

#region 2. Number of Inactive Days

# Prompt the user for the number of inactive days.
# Store it ona temporary variable
$inputDays = Read-Host "Enter the number of inactivity days you are auditing for? (e.g., 30)"

# Validate the input
# Use [int]::TryParse to ensure that the input is a valid positive integer
[int]$inactive_daysValue = 0
if (-not[int]::TryParse($inputDays, [ref]$inactive_daysValue) -or $inactive_daysValue -le 0) {
    Write-Error "Invalid input. Please enter a valid positive integer for inactivity days. Exiting script."
    exit
}
$inactive_days = $inactive_daysValue
# Now we calculate cutoff date based on the user input.
$cutoffDate = (Get-Date).AddDays(-$inactive_days)

#endregion

#region 3. Retrieve AD Users

# Retrieve all AD users including their LastLogonDate property, with error handling.
try {
    $allUsers= Get-ADUser -Filter * -Properties LastLogonDate -ErrorAction Stop
    # Now we filter for inactive users:
    #Including users who have never logged in ($LastLogonDate is $null) or whose LastLogonDate is before the cutoff.
    $inactiveUsers = $allUsers | Where-Object { ($_.LastLogonDate -eq $null) -or ($_.LastLogonDate -lt $cutoffDate) }
}
catch {
    Write-Error "Unable to retrieve AD users due to connectivity or insufficient permissions"
    exit
}
#endregion

#region 4. Split inactive Users into two groups

# Group 1: Never logged in.
# Group 2: LastLogonDate but inactive -lt the provided cutoffDate.
$neverLoggedIn = $inactiveUsers | Where-Object { $_.LastLogonDate -eq $null}
$loggedInactive = $inactiveUsers | Where-Object { $_.LastLogonDate -ne $null}

#endregion

#region 5. Summary

# Sorts by users who have logged in
# and displays a detailed listing of inactive users.
Write-Host "`n Detailed Inactive User List:"
$inactiveUsers | Sort-Object @{
    Expression = { if ($_.LastLogonDate -eq $null) { 1 } else {0} }
}, LastLogonDate | Format-Table Name, SamAccountName, LastLogonDate -AutoSize

# Count totals for summary.
$totalInactive = ($inactiveUsers | Measure-Object).Count
$totalNeverLogged = ($neverLoggedIn | Measure-Object).Count
$totalLoggedInactive = ($loggedInactive | Measure-Object).Count

# Output a detailed summary including cutoff date and breakdown of inactive accounts.
Write-Host "`nSummary:"
Write-Host "User selected $inputDays days of inactivity."
Write-Host "Cutoff Date for inactivity: $cutoffDate"
Write-Host "Total inactive accounts: $totalInactive"
Write-Host " - Accounts that never logged in: $totalNeverLogged"

#endregion