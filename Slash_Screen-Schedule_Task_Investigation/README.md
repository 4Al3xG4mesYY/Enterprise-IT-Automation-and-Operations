### Overview
I was given a small task patching device with a Windows machine in a lab. Some were automatically updated and others were manually updated due to some company policy. Anyway, I make sure those devices are updated for monthly updates. That would include security updates and other features for July 2026 and so on. 

### Problem
When I login with a specific domain with my credentials as usual. One of the machines I encountered had a splash screen. I wasn't able to traditionally pull the command prompt or showing the usual background. It was mainly the screen background black, and the company logo block the screen.

### Investigation
I tried to see if it was my credentials that wasn't working and then I tried accessing the registry editor that was running the shell scheduled task. It turns out I need elevated privileges, but when I tried running as admin when navigating through task manager opening a service and then running regedit as admin. My credentials inputted gotten an error with "The requested operations require elevation." That concluded that I didn't have the permissions run as admin.

### Challenges Encountered
Challenges that I encountered was figuring out whether it was the domain and my credentials or miss input on my part. Later it was accessing the command prompt and the run command, I found difficulty to knowing how to get them without the shortcuts. There was also figuring out how to modify regedit with elevated privileges. 

### Resolution
I asked my senior for help for navigating through the commands and such. I told them the errors I have with the operations, but I was able to access regedit. The problem was I wasn't using the local account that would be selected as admin looking through the computer management and local account is a part of the administrator group. Later we access the feature pressing file and accessing the command prompt rather than the shortcut. Next we rebooted and access normally and getting the update completed.

### Lessons Learned
* Administrative context matters when troubleshooting Windows systems.
* Local credentials and domain credentials can behave differently.
* Scheduled tasks can affect shell initialization and user accessibility.
* Escalating appropriately is part of effective troubleshooting.

### Future Improvements
* Use local account first to access
* Recognize how to access the command prompt from file explorer
* Keep great communication with seniors
