#!/bin/bash
#@Author mlizbeth 
#@Date 7-26-19
#@Version 1.0
#FACULTY/STAFF ONLY
#TODO change lab imaging to have the same identifier
apiUser="$4"
apiPass="$5"
jssURL=$(/usr/bin/defaults read /Library/Preferences/com.jamfsoftware.jamf.plist jss_url | /usr/bin/sed s'/.$//')
udid=$(/usr/sbin/system_profiler SPHardwareDataType | /usr/bin/awk '/UUID/ { print $3; }')
install_date=$(/usr/bin/curl -X GET --user "$apiUser:$apiPass" "$jssURL/JSSResource/computers/udid/$udid" | /usr/bin/xmllint --xpath "//name[text()='Installation Date']/following-sibling::value/text()" -)
if [ ! "$install_date" ]; then #find install date from file
	if [ -f /var/db/receipts/edu.trinity.enrollment.plist ]; then
		date=$(/usr/bin/defaults read /var/db/receipts/edu.trinity.enrollment.plist InstallDate | /usr/bin/awk '{print $1"\ "$2}')
		/bin/echo "<result>$date</result>"
	fi
fi 
# if already populated, do nothing
