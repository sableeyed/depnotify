# DEPNotify via LaunchDaemon
This project is still a work in progress, though it does appear to function properly.
Using the Jamf Professional Services DEPNotifyStarter script didn't work well for our devices. Sometimes it'd crash, other times the GUI for DEPNotify would crash.
Researching for solutions led me to [Updating Our DEPNotify Process With a LaunchDaemon](https://yearofthegeek.net/2018/05/updating-our-depnotify-process/) where I used some his code along with the Jamf script to build a custom workflow.

## Package Hierarchy Overview
![Overview](https://raw.githubusercontent.com/mlizbeth/depnotify_launchd/master/img/1.png)

## Credits
Thanks to [jmahlman](https://github.com/jmahlman/DEPNotify-automated) for his article on how he created this.

Thanks to [Jamf Professional Services](https://github.com/jamf/DEPNotify-Starter) for their DEP Script.
