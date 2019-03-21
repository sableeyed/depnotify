### This is not production ready yet ###

#!/bin/bash
setupDone="/Library/Application\ Support/Jamf/setupDone"
dLOG=/var/tmp/depnotify.log
dLIST=/var/tmp/DEPNotify.plist
JAMF_BINARY=/usr/local/bin/jamf
CURRENTUSER=$(/usr/bin/python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')
inputList="/Users/$CURRENTUSER/Library/Preferences/menu.nomad.DEPNotifyUserInput.plist"
configList="/Users/$CURRENTUSER/Library/Preferences/menu.nomad.DEPNotify.plist"
BANNER_IMG="/var/tmp/banner.png"
REGISTRATION_DONE="/var/tmp/com.depnotify.registration.done"

POLICY_ARRAY=(
    #"Binding to Active Directory,ADBIND"
  	#"Installing Google Chrome,CHROME"
  	#"Installing Mozilla Firefox,FIREFOX"
  	#"Installing VLC Media Player,VLC"
  	#"Installing Java Runtime Environment,JRE"
  	#"Installing Adobe Flash Player,FLASH"
    #"Installing Microsoft Office 2019,O2019"
    #"Installing BitDefender,BDFS"
    #"Enabling Remote Management,SCRIPTS"
    #"Installing Updates,UPDATES"
    #"Installing KACE Agent,KACE"
)

#if [ -f "${setupDone}" ]; then exit 0; fi

if pgrep -x "Finder" \
	&& pgrep -x "Dock" \
	&& [ "$CURRENTUSER" != "_mbsetupuser" ] \
	&& [ ! -f "${setupDone}" ]; then

		/usr/bin/caffeinate -d -i -m -u -s &
		caffeinatepid=$!

		#killall Installer
		echo "Hello"

		sleep 5

		# Register input plist 
		sudo -u "$CURRENTUSER" defaults write "$configList" pathToPlistFile "$inputList"

		# Global app preferences
		sudo -u "$CURRENTUSER" defaults write "$configList" statusTextAlignment center

		echo "Status: Performing black magic..." >> $dLOG

		# Main Window Look'n'Feel
		echo "Command: Image: /var/tmp/banner.png" >> $dLOG
		echo "Command: MainTitle: New Mac Deployment" >> $dLOG
		echo "Command: MainText: Make sure the device is using a wired connection before proceeding. This process should take approximately 20-30 minutes and the machine will reboot when completed. \n \n Additional software can be found in the Self Service app" >> $dLOG
		echo "Command: ContinueButtonRegister: Begin Registration" >> $dLOG
		
		# Registration Window Look'n'Feel
		sudo -u "$CURRENTUSER" defaults write "$configList" registrationTitleMain "Enter Device Details"
		sudo -u "$CURRENTUSER" defaults write "$configList" registrationPicturePath "$BANNER_IMG"
		sudo -u "$CURRENTUSER" defaults write "$configList" registrationButtonLabel "Register & Image Device"

		sudo -u "$CURRENTUSER" defaults write "$configList" textField1Label "Device Name"
		sudo -u "$CURRENTUSER" defaults write "$configList" textField1Placeholder "DEPT-USER"
		sudo -u "$CURRENTUSER" defaults write "$configList" textField1IsOptional -bool false

		sudo -u "$CURRENTUSER" defaults write "$configList" textField2Label "Asset Tag"
		sudo -u "$CURRENTUSER" defaults write "$configList" textField2Placeholder "08136249"
		sudo -u "$CURRENTUSER" defaults write "$configList" textField2IsOptional -bool true

		sudo -u "$CURRENTUSER" defaults write "$configList" popupButton1Label "Building"
		sudo -u "$CURRENTUSER" defaults write "$configList" popupButton1Content -array "ayy" "lmao"

		sudo -u "$CURRENTUSER" defaults write "$configList" popupButton2Label "Department"
		sudo -u "$CURRENTUSER" defaults write "$configList" popupButton2Content -array "420" "xd"


		# Open DepNotify
	    sudo -u "$CURRENTUSER" /Applications/Utilities/DEPNotify.app/Contents/MacOS/DEPNotify &

	    while [ ! -f "$REGISTRATION_DONE" ]; do
	    	echo "$(date "+%a %h %d %H:%M:%S"): Waiting on conpletion of registration" >> $dLOG
	    	sleep 1
	    done

	    #Read and Set Computer Name/Asset Tag/Building/Department

	    #Update the statuses appropriately

fi


# Loop to run policies
# for POLICY in "${POLICY_ARRAY[@]}"; do
#   echo "Status: $(echo "$POLICY" | cut -d ',' -f1)" >> "$dLOG"
#     "$JAMF_BINARY" policy -event "$(echo "$POLICY" | cut -d ',' -f2)"
# done


