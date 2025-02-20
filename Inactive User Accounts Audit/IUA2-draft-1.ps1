# Inactive User Accounts Audit Script

# This PowerShell script goes through Users in the domains Active Directory
# and finds all users that have been inactive for more than 31 days.

# We start off by adding the AD module
Import-Module ActiveDirectory

# Now we create the cutoffDate variable of 31 days (make sure to lower for testing purposes)
$cutoffDate = (Get-Date).AddDays(-31)

# Next we access the domain to retrieve all users who meet the criteria and set them in the inactive Users variable
$inactiveUsers= Get-ADUser -Filter * -Properties LastLogonDate | Where-Object {($_.LastLogonDate -eq $null) -or ($_.LastLogonDate -lt $cutoffDate)}

# Now we list the inactive users (later I will add a way to display something for those who have
# never logged in.
$inactiveUsers | Format-Table Name, SamAccountName, LastLogonDate -AutoSize

# Get the total count of inactive users
$totalInactive = ($inactiveUsers | Measure-Object).Count

#Display the summary
Write-Host "`nTotal inactive accounts: $totalInactive "