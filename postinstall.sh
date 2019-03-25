#!/bin/bash
chmod a+x /var/tmp/depNotify.sh
chmod 644 /Library/LaunchDaemons/edu.trinity.launch.plist
chown root:wheel /Library/LaunchDaemons/edu.trinity.launch.plist
launchctl bootstrap system /Library/LaunchDaemons/edu.trinity.launch.plist