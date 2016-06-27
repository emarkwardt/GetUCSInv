# Date: 2012/12/13
# Description: This is a sample inventory report from UCS Manager
# The report uses Windows PowerShell and the Cisco UCS PowerTool found at:
# http://developer.cisco.com/web/unifiedcomputing/pshell-download

# Import the UCS PowerTool module
Import-Module "C:\Program Files (x86)\Cisco\Cisco UCS PowerTool\Modules\CiscoUCsPS\CiscoUcsPS.psd1"

# Define UCS connection details.  Edit to match your environment.
$ucsSysName = "10.91.42.62"
$ucsUserName = "admin"
$ucsPassword = “adminpassword”

# The UCSM connection requires a PSCredential to login, so we must convert
# our plain text password to make an object
$ucsPassword = ConvertTo-SecureString -String $ucsPassword -AsPlainText -Force
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $ucsUserName, $ucsPassword

#
# alternatively use Get-Credential to prompt the user for login credentials
#
#$cred = Get-Credential

# Create connection to UCS system
$ucsConnection = Connect-Ucs $ucsSysName -Credential $cred

# Generate a report of the UCS
Write-Host "General UCS Information"
get-UcsStatus | Format-Table -Autosize Name, ChassisSerial1, VirtualIpv4Address, FiAOobIpv4Address, FiBOobIpv4Address

# Generate a report of the Fabric Interconnect pieces
Write-Host "Fabric Interconnect Information"
get-UcsFiModule | Format-Table -Autosize Ucs, Dn, Model, Serial, Descr

# Generate a report of all chassis
Write-Host "Chassis Information"
get-UcsChassis | Format-Table -Autosize Ucs, Dn, Model, Serial, UserLbl

# Generate a report of all of the IOMs
Write-Host "Chassis IO Module Information"
get-UcsIom | Format-Table -Autosize Ucs, Dn, Model, Serial, Descr

# Generate a report on all of the blades
Write-Host "Blade Information"
get-UcsBlade | Format-Table -AutoSize -Wrap Ucs, Dn, AssignedToDn, model, partnumber, serial, numofcpus, totalmemory, descr

#Disconnect from the UCS
Disconnect-Ucs
