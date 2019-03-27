# 3/25/19 Initial Release v1
# 3/25/19 v1.1: Fix array formatting

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

BUILDING_ARRAY=(
	"Chapman Center"
	"Coates University Center"
	"Center for Science & Innovation"
	"Dicke Smith Building"
	"Elizabeth Huth Coates Library"
	"Halsell Administrative Studies"
	"Holt Conference Center"
	"King's Court"
	"Laurie Auditorium"
	"Marrs McLean Hall"
	"Margarite B. Parker Chapel"
	"Northrup Hall"
	"Richardson Communication Center"
	"Ruth Taylor Theatre"
	"Storch Memorial Building"
	"William Bell Center"
	)

DEPARTMENT_ARRAY=(
	"Academic Affairs"
	"Academic Support"
	"Admissions"
	"Alumni Relations & Development"
	"Art & Art History"
	"Athletics"
	"Biology"
	"Business Office"
	"Chemistry"
	"Classical Studies"
	"Collaborative for Learning & Teaching"
	"Communication"
	"Computer Science"
	"Counseling Services"
	"Dean of Students"
	"Economics"
	"Education"
	"Endowments"
	"Engineering"
	"English"
	"Environmental Health & Safety"
	"Facilities Services"
	"Finance & Administration"
	"Geosciences"
	"Health Care Administration"
	"Health Services"
	"History"
	"Human Communication & Theatre"
	"Human Resources"
	"Information Technology Services"
	"Library"
	"Mathematics"
	"Modern Languages & Literatures"
	"Music"
	"Philosophy"
	"Physics & Astronomy"
	"Political Science"
	"President's Office"
	"Psychology"
	"Purchasing"
	"Registrar"
	"Religion"
	"Residential Life"
	"Risk Management & Insurance"
	"School of Business"
	"Sociology & Anthropology"
	"Strategic Communications & Marketing"
	"Student Financial Services"
	"Tiger Card Office"
	"Trinitonian"
	"Trinity University Press"
	"TUPD"
	"Other"
	)

POLICY_ARRAY=(
  	"Installing Google Chrome,CHROME"
  	"Installing Mozilla Firefox,FIREFOX"
  	"Installing VLC Media Player,VLC"
  	"Installing Java Runtime Environment,JRE"
  	"Installing Adobe Flash Player,FLASH"
	"Installing Microsoft Office 2019,O2019"
	"Installing BitDefender,BDFS"
	"Installing KACE Agent,KACE"
	"Enabling Remote Management,SCRIPTS"
	"Installing OS Updates,UPDATES"
	)

if [ -f "${setupDone}" ]; then exit 0; fi

if pgrep -x "Finder" \
	&& pgrep -x "Dock" \
	&& [ "$CURRENTUSER" != "_mbsetupuser" ] \
	&& [ ! -f "${setupDone}" ]; then

		/usr/bin/caffeinate -d -i -m -u -s &
		caffeinatepid=$!

		killall Installer
		pkill "Self Service"

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
		for BUILDING_ARRAY in "${BUILDING_ARRAY[@]}"; do
			sudo -u "$CURRENTUSER" defaults write "$configList" popupButton1Content -array-add "$BUILDING_ARRAY"
		done

		sudo -u "$CURRENTUSER" defaults write "$configList" popupButton2Label "Department"
		for DEPARTMENT_ARRAY in "${DEPARTMENT_ARRAY[@]}"; do
			sudo -u "$CURRENTUSER" defaults write "$configList" popupButton2Content -array-add "$DEPARTMENT_ARRAY"
		done


		# Open DepNotify
	    sudo -u "$CURRENTUSER" /Applications/Utilities/DEPNotify.app/Contents/MacOS/DEPNotify &
	    
	    while [ ! -f "$REGISTRATION_DONE" ]; do
	    	echo "$(date "+%a %h %d %H:%M:%S"): Waiting on completion of registration" >> $dLOG
	    	sleep 2
	    done

	    #Computer Name Logic
	    REG_FIELD_1_VALUE=$(defaults read "$inputList" "Device Name") #This field is mandatory
	    if [ ! "$REG_FIELD_1_VALUE" = "" ]; then
	    	echo "Status: Setting computer name to $REG_FIELD_1_VALUE" >> $dLOG
	    	scutil --set HostName "$REG_FIELD_1_VALUE"
	    	scutil --set LocalHostName "$REG_FIELD_1_VALUE"
	    	scutil --set ComputerName "$REG_FIELD_1_VALUE"
	    	$JAMF_BINARY setComputerName -name "$REG_FIELD_1_VALUE"
	    else
	    	echo "Status: Something went wrong because DEVICE_NAME can't be empty." >> $dLOG
	    	exit 1
	    fi

	    # Asset Tag Logic
	    REG_FIELD_2_VALUE=$(defaults read "$inputList" "Asset Tag")
	    REG_FIELD_2_OPTIONAL=$(defaults read "$configList" "textField2IsOptional")
	    if [ "$REG_FIELD_2_OPTIONAL" = 1 ] && [ "$REG_FIELD_2_VALUE" = "" ]; then
	    	echo "Status: Asset tag was left empty. Skipping..." >> $dLOG
	    	sleep 2
	    else #set the asset tag
	    	echo "Status: Setting asset tag to $REG_FIELD_2_VALUE." >> $dLOG
	    	$JAMF_BINARY recon -assetTag "$REG_FIELD_2_VALUE"
	    fi

	    #Device Building Logic
	    REG_FIELD_3_VALUE=$(defaults read "$inputList" "Building")
	    if [ ! "$REG_FIELD_3_VALUE" = "" ]; then
	    	echo "Status: Setting building to $REG_FIELD_3_VALUE" >> $dLOG
	    	$JAMF_BINARY recon -building "$REG_FIELD_3_VALUE"
	    else
	    	echo "Something went wrong when setting BUILDING" >> $dLOG
	    	exit 1
	    fi


	    #Device Department Logic
	    REG_FIELD_4_VALUE=$(defaults read "$inputList" "Department")
	    if [ ! "$REG_FIELD_4_VALUE" = "" ]; then
	    	echo "Status: Setting department to $REG_FIELD_4_VALUE" >> $dLOG
	    	"$JAMF_BINARY" recon -department "$REG_FIELD_4_VALUE"
	    else
	    	echo "Something went wrong when setting DEPARTMENT" >> $dLOG
	    	exit 1
	    fi


	    #Begin device imaging
	    for POLICY in "${POLICY_ARRAY[@]}"; do
  			echo "Status: $(echo "$POLICY" | cut -d ',' -f1)" >> "$dLOG"
     		"$JAMF_BINARY" policy -event "$(echo "$POLICY" | cut -d ',' -f2)"
		done

		touch $setupDone #Plan to remove this but its a legacy EA until I could place the bom on already deployed machines
		touch /var/db/receipts/edu.trinity.imaging.bom
		echo "Status: Updating device inventory" >> $dLOG
		$JAMF_BINARY recon
		echo "Status: Cleaning up files and restarting the system" >> $dLOG
		sleep 2
		kill $caffeinatepid
		rm -fr /Library/LaunchDaemons/edu.trinity.launch.plist
		rm -fr $inputList
		rm -fr $configList
		rm -fr /var/tmp/banner.png
		pwpolicy -a admin -u "$CURRENTUSER" -setpolicy "newPasswordRequired=1"
		echo "Command: RestartNow:" >> $dLOG

		rm -fr /Applications/Utilities/DEPNotify.app
		rm -- "$0"
fi
exit 0
