#!/bin/bash

# Disable Time Machine's pop-up message whenever an external drive is plugged in

defaults write /Library/Preferences/com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Turn off DS_Store file creation on network volumes

defaults write /System/Library/User\ Template/English.lproj/Library/Preferences/com.apple.desktopservices DSDontWriteNetworkStores true

# Globally Set Expanded Print Dialouge Box

defaults write /Library/Preferences/.GlobalPreferences PMPrintingExpandedStateForPrint -bool true

# Set the login window to name and password

defaults write /Library/Preferences/com.apple.loginwindow SHOWFULLNAME -bool true 

# Use short-name for logging into Network Share

defaults write /Library/Preferences/com.apple.NetworkAuthorization UseDefaultName -bool NO
defaults write /Library/Preferences/com.apple.NetworkAuthorization UseShortName -bool YES

# Disable Guest Sharing

defaults write /Library/Preferences/com.apple.AppleFileServer guestAccess -bool NO

# Disable external accounts

defaults write /Library/Preferences/com.apple.loginwindow EnableExternalAccounts -bool false


# Disable 'shake mouse to locate' - 10.11
defaults write /System/Library/User\ Template/English.lproj/Library/Preferences/.GlobalPreferences CGDisableCursorLocationMagnification -bool true

#set scroll direction
defaults write /System/Library/User\ Template/English.lproj/Library/Preferences/.GlobalPreferences com.apple.swipescrolldirection -bool false

exit 0
