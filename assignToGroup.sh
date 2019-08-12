#!/bin/bash
apiUser="user"
apiPass="pass"
jssURL=$(/usr/bin/defaults read /Library/Preferences/com.jamfsoftware.jamf.plist jss_url | /usr/bin/sed s'/.$//')
groupID="##"
apiURL="JSSResource/computergroups/id/${groupID}"
computerName=$(hostname)
xmlHeader="<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>"
apiData="<computer_group><id>${groupID}</id><name>Group name</name><computer_additions><computer><name>$computerName</name></computer></computer_additions></computer_group>"

/usr/bin/curl -sSkiu ${apiUser}:${apiPass} "${jssURL}/${apiURL}" \
    -H "Content-Type: text/xml" \
    -d "${xmlHeader}${apiData}" \
    -X PUT  > /dev/null