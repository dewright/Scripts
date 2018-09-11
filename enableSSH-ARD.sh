#!/bin/sh

# Enable ARD, VNC & SSH on systems where it has been disabled

kickstart="/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart"
manageacct="<MGMT ACCOUNT HERE>"
admingroup="admin"
admingroupID="ABCDEFAB-CDEF-ABCD-EFAB-CDEF00000050"

# check to be sure script is running as root

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi


enableARD (){ ## Enable ARD & VNC for management account access

# Disable access for all users, allow specific users only
$kickstart -configure -allowAccessFor -specifiedUsers

# Require VNC, screen-sharing and control fuctions to require a request for access
$kickstart -configure -clientopts -setreqperm -reqperm yes 

# Enable accesss and grant all permissions to management account
$kickstart -configure -access -on -users "$manageacct" -privs -all 

# Activate and restart agent
$kickstart -activate -restart -agent -console
}


## Enable SSH

enableSSH (){ ## Enable SSH for managment account and all admin users

# Check for access restrictions
# If all users are allowed access, leave alone
# If specific users are allowed access, add mskcc

# Check if ssl access is currently restricted, if not, enable ACL

sshACL=$(/usr/bin/dscl . list /Groups | grep "com.apple.access_ssh")

if [[ $sshACL == "com.apple.access_ssh-disabled"]]; then
	echo "ssh is currently unrestricted, creating ssh access group"
	dscl . change /Groups/com.apple.access_ssh-disabled RecordName com.apple.access_ssh-disabled com.apple.access_ssh
elif [[ -z $sshACL ]]; then
	echo "no ssh access group found, creating ssh access group"
	dseditgroup -o create -q com.apple.access_ssh
fi

#add management account to ssh access control list
manageacctSSH="$(dscl . -read /Groups/com.apple.access_ssh | grep "GroupMembership:" | grep "$manageacct")"
if [[ -z  $manageacctSSH ]]; then
	echo "management account not in ssh access group, adding management account"
	dseditgroup -o edit -a "$manageacct" -t user com.apple.access_ssh
fi

#add local machine admin group to ssh access control list
adminSSH="$(dscl . -read /Groups/com.apple.access_ssh | grep "NestedGroups:" | grep "$admingroupID")"
if [[ -z $adminSSH ]]; then
	echo "adding local machine admin group to ssh access group"
	dseditgroup -o edit -a "$admingroup" -t group com.apple.access_ssh
fi

# Check if ssh is enabled, if not, then enable it
sshStatus="$(systemseup -getremotelogin | awk '{print $3}' )"
if [[ "$sshStatus" != "On" ]]; then
	echo "ssh not enabled, enabling ssh"
	systemsetup -setremotelogin on
fi
}

## The big show

enableARD

enableSSH

exit 0                                                 
