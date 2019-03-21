#!/bin/bash
chmod a+x /var/tmp/depNotify.sh
chmod 644 /Library/LaunchDaemons/edu.trinity.launch.plist
chown root:wheel /Library/LaunchDaemons/edu.trinity.launch.plist
launchctl load /Library/LaunchDaemons/edu.trinity.launch.plist