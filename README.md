# DEPNotify via LaunchDaemon
This project is still a work in progress, though it does appear to function properly.
I tried Using the Jamf DEPNotify-starter script but ran into a myriad of problems. I wasn't sure if the problem was Jamf, DEPNotify, the script or our workflow. I spent about 20 hours debugging the cause with no success. Sometimes the entire process would crash, other times the GUI for DEPNotify would freeze but the script would continue execution in the background. 
Researching for solutions led me to [Updating Our DEPNotify Process With a LaunchDaemon](https://yearofthegeek.net/2018/05/updating-our-depnotify-process/), where I used some his code along with the Jamf script to build a custom workflow.
Since our technicians are imaging the devices before sending them to users it is not as imperative to have a fully functioning solution, however my goal with this was to allow them to get as close as possible to a no touch deployment and eventually allow the end users to complete this process, giving the technicians more time to do what matters.

### This is not a catch-all solution. It has been tailored to our current workflow, which is subject to change. Please consider looking at the jamf script if you need a more generic solution.

## Package Hierarchy Overview
![Overview](https://raw.githubusercontent.com/mlizbeth/depnotify_launchd/master/img/1.png)

## Workflow
#### In our prestage we skip all options except location services and account creation
1. Technician goes through setup assistant as usual
2. Creates an account for the user
3. Mac will auto login to the desktop
4. Wait
5. DEPNotify will start within a minute
6. Technician enters Computer name, assignee AD name, building and department
7. Device will will self image and restart when finished
8. Technicians can install additional software in self service or deploy the device

## TODO
* ~Add FileVault~
* Remove Policy Array so it can be modified without having to rebuild the package
* ~~Force the user to change password at the NEXT login~~

## Credits
Thanks to [jmahlman](https://github.com/jmahlman/DEPNotify-automated) for his article on how he created this.

Thanks to [Jamf Professional Services](https://github.com/jamf/DEPNotify-Starter) for their DEP Script.
