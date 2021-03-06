# WinWebDevProMgr
_Windows Web Development Project Manager_
- Installs the **MEN (MongoDB | Express | Node.js) stack** on Windows machine.
- Creates single workspace for all web applications.
- Creates **MVC** (Media Controller View) Structure for web applications.
- Create every new web application with a ready to deploy hello world tempalte.
- Provide set of commands to ease the deploy of web application.
- Install necessary fixes automatically.
- Convert itself from Installer Program to Main Program.

## Installation
- Copy the code from here ([32bit](Win32WebDevProMgr_Installer.bat) or [64bit](Win64WebDevProMgr_Installer.bat)) and save it as **`Win32WebDevProMgr_Installer.bat for 32bit or Win64WebDevProMgr_Installer.bat for 64bit`** on your **desktop**.
- **Note : File name should be exact as given above and file should be saved on desktop only. Later I will make it operable from anywhere.**
- Now run the file and wait while it prepares the whole setup for first time only.
- **Note : Installation process requires internet connection. Installation time depends upon your internet speed so have patience.**
- After completion of installtion process a **necessary update (hotfix KB2731284)** will be installed in consecution and forces a restart.
- Installation is complete! After the restart workspace named **WebProjects** will be there on your desktop.

## Main Program
- Open the workspace (**WebProjects**) and run **Win32WebDevProMgr.bat or Win64WebDevProMgr.bat** and use it to make your app.

## Commands
- **`-new`** : To create a new project.
- **`-run appName`** : To run an app.
- **`-appd appName`** : To go in an app's directory.
- **`-node nodeCommand`** : To run node command after -appd command
- **`-npm npmCommand`** : To run npm command after -appd command
- **`-openode npmCommand`** : To run openode command after -appd command
     - Install openode before using this.
     - To install openode globally first run **`-appd`** then **`-npm install -g openode`**.
     - You can enter your app's directory by **`-appd appName`** and then can deploy it to openonde server by **`-openode deploy`**.
- **`-mongod`** : To run MongoDB.
- **`-mongo`** : To run MongoDB shell.
- **`-cmd`** : To enter Command Prompt.
- **`-return`** : To leave Command Prompt and App's Directory.
- **`-exit`** : To close the main program.

_Windows 7 my first love_ <3 :)
