# Inactive User Accounts Audit
This PowerShell script audits Active Directory for user accounts that have not logged on for a specified period (e.g., 90 days) and outputs a detailed summary of inactive accounts.

## 📌 How It Works:
- Imports the Active Directory module.
- Retrieves all AD users along with their `LastLogonDate` property.
- Filters for users whose last logon date is older than a specified cutoff (e.g., 31 days ago).
- Counts and lists inactive accounts with details such as Name, SamAccountName, and LastLogonDate.
- Outputs a summary showing the total number of inactive accounts.

## 🚀 Why This Project?
As a server administrator for 4 years, I'm now taking PowerShell more seriously.  
This project is part of my **learning journey**—breaking down larger scripts into **small, manageable steps**.

Auditing inactive accounts helps improve security by identifying and addressing unused or potentially vulnerable user accounts in Active Directory.

## 🛠 Try It Yourself!
1. Ensure the Active Directory module is installed and you have the necessary permissions.
2. Run the script in PowerShell.
3. Review the detailed list and summary of inactive accounts.
4. (Optional, Coming Soon!) Run the test script in the `test-files/` directory, which creates 4 test users marked as inactive.

## 🔄 Posted and Upcoming Script Versions:
- `IUA2-draft-1.ps1` → Initial version that retrieves and filters inactive accounts with basic output.
- `IUA2-draft-2.ps1` → Coming Soon! Improved version with User select number of inactivity days, enhanced error handling, a more detailed listing, and an initial summary.
- `IUA2-final.ps1` → Coming Later. Planned enhancements include:
  - **Enhanced Summary & Reporting:** Configure the summary to provide a detailed list and automatically email it to an address provided at the beginning.
  - **OU Filtering:** Allow the script to target a specific OU, multiple OUs (separated by commas), or the entire directory.
  - **Manager Notifications:** Ask if the summary should also be sent to all managers or selected managers of the OU to which the inactive users belong.

---
Thanks for stopping by! 🖥️