rem ==================================================
rem console view settings
rem ==================================================
@echo off
setlocal enabledelayedexpansion
rem echo in different colours
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do     rem"') do (
  set "DEL=%%a"
)
title Windows 64bit Web Development Project Manager
mode con: cols=100 lines=30
color 0a

rem ==================================================
rem delete intalled hotfix KB2731284
rem ==================================================
if exist HotfixKB2731284.msu del HotfixKB2731284.msu

rem ==================================================
rem check if installation is needed
rem ==================================================
if exist %userprofile%\Desktop\WebProject\Win64WebDevProMgr.bat (
	goto :installed
) else (
	rem ==================================================
	rem create workspace WebProject
	rem ==================================================
	md WebProject
	cd WebProject

	rem ==================================================
	rem 7za console version for unzipping files
	rem ==================================================
	:download7za
	cls
	call :colorEcho 0b "======================================================="
	echo.
	echo Downloading 7za.exe
	call :colorEcho 0b "======================================================="
	echo.
	echo.
	powershell "Import-Module BitsTransfer; Start-BitsTransfer 'https://raw.githubusercontent.com/riuandg5/WinWebDevProMgr/master/7za64.exe' '7za.exe'"
	if not exist 7za.exe goto :download7za

	rem ==================================================
	rem download node.zip
	rem ==================================================
	:downloadNode
	cls
	call :colorEcho 0b "======================================================="
	echo.
	echo Downloading Node.js
	call :colorEcho 0b "======================================================="
	echo.
	echo.
	powershell "Import-Module BitsTransfer; Start-BitsTransfer 'https://nodejs.org/dist/v8.10.0/node-v8.10.0-win-x64.zip' 'node.zip'"
	if not exist node.zip goto :downloadNode

	rem ==================================================
	rem unzip node.zip files in folder Node
	rem ==================================================
	7za x "node.zip" -y
	for /d %%j in ("..\WebProject\*") do ren %%~fj Node

	rem ==================================================
	rem download mongodb.zip
	rem ==================================================
	:downloadMongodb
	cls
	call :colorEcho 0b "======================================================="
	echo.
	echo Downloading MongoDB
	call :colorEcho 0b "======================================================="
	echo.
	echo.
	powershell "Import-Module BitsTransfer; Start-BitsTransfer 'http://downloads.mongodb.org/win32/mongodb-win32-x86_64-v3.0-latest.zip?_ga=2.28077436.1988013442.1522070652-1374276939.1522070652' 'mongodb.zip'"
	if not exist mongodb.zip goto :downloadMongodb
	
	rem ==================================================
	rem unzip mongodb.zip files in folder MongoDB\mongodb
	rem ==================================================
	7za x "mongodb.zip" -o"MongoDB" -y
	for /d %%j in ("MongoDB\*") do ren %%~fj mongodb
	
	rem ==================================================
	rem create MongoDB\data\db for data storage
	rem create workspace for all WebApps
	rem ==================================================
	md MongoDB\data\db WebApps

	rem ==================================================
	rem delete zip files and 7za
	rem ==================================================
	del node.zip
	del mongodb.zip
	del 7za.exe

	rem ==================================================
	rem download and install hotfix KB2731284
	rem ==================================================
	:downloadHotfix
	cls
	call :colorEcho 0b "======================================================="
	echo.
	echo Downloading And Installing Hotfix KB2731284
	call :colorEcho 0b "======================================================="
	echo.
	echo.
	powershell "Import-Module BitsTransfer; Start-BitsTransfer 'https://raw.githubusercontent.com/riuandg5/WinWebDevProMgr/master/Windows6.1-KB2731284-v3-x64.msu' 'HotfixKB2731284.msu'"
	if not exist HotfixKB2731284.msu goto :downloadHotfix
	start HotfixKB2731284.msu

	rem ==================================================
	rem convert installer to app and move to WebProject
	rem delete installer
	rem ==================================================
	copy ..\Win64WebDevProMgr_Installer.bat
	ren Win64WebDevProMgr_Installer.bat Win64WebDevProMgr.bat
	del ..\Win64WebDevProMgr_Installer.bat

	exit
)
:installed
:main
cls
rem ==================================================
rem default path for all projects
rem ==================================================
set webProPath=%userprofile%\Desktop\WebProject
set nodePath=%userprofile%\Desktop\WebProject\Node
set mongoPath=%userprofile%\Desktop\WebProject\MongoDB
set appPath=%userprofile%\Desktop\WebProject\WebApps
cd /d !webProPath!

call :colorEcho 0b "======================================================="
echo.
echo WINDOWS 64bit WEB DEVELOPMENT PROJECT MANAGER BY REU
call :colorEcho 0b "======================================================="
echo.
echo New Project               :      -new
echo.
echo Run App                   :      -run appName
echo.
echo Go to App Directory       :      -appd appName
echo.
echo Run MongoDB               :      -mongod
echo.
echo Run MongoDB Shell         :      -mongo
echo.
echo Command Prompt            :      -cmd
echo.
echo Leave CMD and App Dir     :      -return
echo.
echo To Exit                   :      -exit
call :colorEcho 0b "======================================================="
echo.
echo.
set /p input=!userName! 
echo !input!|findstr /i /x "^-new" >nul && goto :newProject
echo !input!|findstr /i "^-run" >nul && goto :runApp
echo !input!|findstr /i "^-appd" >nul && goto :appDirectory
echo !input!|findstr /i /x "^-mongod" >nul && goto :runMongod
echo !input!|findstr /i /x "^-mongo" >nul && goto :runMongo
echo !input!|findstr /i /x "^-cmd" >nul && (echo. && goto :cmdPrompt)
echo !input!|findstr /i /x "^-exit" >nul && exit
echo.
goto :main

:cmdPrompt
set /p cmdInput=!cd!^>
echo !cmdInput!|findstr /i /x "^-return" >nul && goto :main
call !cmdInput!
echo.
goto :cmdPrompt

:runApp
echo.
cd !appPath!\!input:~5!
call !nodePath!\node server.js
echo.
goto :main

:appDirectory
cd !appPath!\!input:~6!
echo.
set /p appInput=!cd!^>
echo !appInput!|findstr /i "^-node" >nul && goto :nodeCommand
echo !appInput!|findstr /i "^-npm" >nul && goto :npmCommand
echo !appInput!|findstr /i "^-openode" >nul && goto :openodeCommand
echo !appInput!|findstr /i /x "^-return" >nul && goto :main
goto :appDirectory

:nodeCommand
echo.
call !nodePath!\node !appInput:~6!
goto :appDirectory

:npmCommand
echo.
call !nodePath!\npm !appInput:~5!
goto :appDirectory

:openodeCommand
echo.
call !nodePath!\openode !appInput:~9!
goto :appDirectory

:runMongod
start !mongoPath!\mongodb\bin\mongod.exe --dbpath "!mongoPath!\data\db" --journal  --storageEngine=mmapv1
goto :main

:runMongo
echo.
call !mongoPath!\mongodb\bin\mongo.exe
echo.
goto :main

:newProject
cls
rem ==================================================
rem project name
rem ==================================================
call :colorEcho 0b "======================================================="
echo.
set /p projectName=Project Name - 
call :colorEcho 0b "======================================================="
echo.
md !appPath!\!projectName: =!
cd !appPath!\!projectName: =!
echo.

rem ==================================================
rem create package.json file for project
rem ==================================================
call :colorEcho 0b "======================================================="
echo.
echo Initialising package.json configuration...
call :colorEcho 0b "======================================================="
echo.
echo.
call !nodePath!\npm init
echo.

rem ==================================================
rem create MVC Structure for project
rem ==================================================
call :colorEcho 0b "======================================================="
echo.
echo Making Model View Controller Structure...
call :colorEcho 0b "======================================================="
echo.
echo.
md app && cd app
md controllers models routes views
cd views
md partials
cd ../..
md config && cd config
md env
cd ..
md public && cd public
md css img js
cd ..
tree
echo.

rem ==================================================
rem install node modules
rem ==================================================
call :colorEcho 0b "======================================================="
echo.
echo EXPRESS, EJS and REQUEST will be  installed by default.
echo.
set /p packages=Name other packages you want to install - 
call :colorEcho 0b "======================================================="
echo.
echo.
call !nodePath!\npm install --save express ejs request !packages!
echo.

call :colorEcho 0b "======================================================="
echo.
echo Writing commonly used files...
call :colorEcho 0b "======================================================="
echo.
echo.

rem app/controllers/index.server.controller.js
rem ==========================================
(
    echo exports.render = function^(req, res^) {
    echo 	res.render^("index"^)
	echo };
)>>app/controllers/index.server.controller.js
echo Made root controller..
echo.

rem app/controllers/notfound.server.controller.js
rem ==========================================
(
    echo exports.render = function^(req, res^) {
    echo 	res.render^("notfound"^)
	echo };
)>>app/controllers/notfound.server.controller.js
echo Made page not found controller..
echo.

rem app/routes/index.server.routes.js
rem =================================
(
	echo module.exports = function^(app^) {
	echo     var index = require^("../controllers/index.server.controller"^);
	echo     app.get^("/", index.render^);
	echo };
)>>app/routes/index.server.routes.js
echo Made root path..
echo.

rem app/routes/notfound.server.routes.js
rem =================================
(
	echo module.exports = function^(app^) {
	echo     var notfound = require^("../controllers/notfound.server.controller"^);
	echo     app.get^("*", notfound.render^);
	echo };
)>>app/routes/notfound.server.routes.js
echo Made page not found path..
echo.

rem app/views/index.ejs
rem ===================
(
	echo ^<%% include partials/header.ejs %%^>
	echo ^<h1^>Hello world!^</h1^>
	echo ^<%% include partials/footer.ejs %%^>
)>>app/views/index.ejs
echo Made root template..
echo.

rem app/views/notfound.ejs
rem ===================
(
	echo ^<%% include partials/header.ejs %%^>
	echo ^<h1^>YOU ARE LOST :^(^</h1^>
	echo ^<%% include partials/footer.ejs %%^>
)>>app/views/notfound.ejs
echo Made page not found template..
echo.

rem app/views/partials/header.ejs
rem =============================
(
	echo ^<!DOCTYPE html^>
	echo ^<html lang="en"^>
	echo ^<head^>
    echo ^<meta charset="UTF-8"^>
    echo ^<meta name="viewport" content="width=device-width, initial-scale=1.0"^>
    echo ^<meta http-equiv="X-UA-Compatible" content="ie=edge"^>
    echo ^<title^>^</title^>
    echo ^<link href="https://fonts.googleapis.com/css?family=Ubuntu" rel="stylesheet"^>
    echo ^<link rel="stylesheet" href="/css/style.css"^>
	echo ^</head^>
	echo ^<body^>
)>>app/views/partials/header.ejs
echo Made header template..
echo.

rem app/views/partials/footer.ejs
rem =============================
(
	echo ^</body^>
	echo ^</html^>
)>>app/views/partials/footer.ejs
echo Made footer template..
echo.

rem public/css/style.css
rem ====================
(
	echo *{
    echo 	-webkit-box-sizing: border-box;
    echo    	box-sizing: border-box;
    echo	margin: 0;
    echo	padding: 0;
    echo	font-family: 'Ubuntu',sans-serif;
    echo	text-decoration: none;
	echo }
	echo.
	echo body{
    echo background: black;
    echo color: white;
	echo }
)>>public/css/style.css
echo Made styling sheet..
echo.

rem config/express.js
rem =================
(
	echo var express = require^("express"^);
	echo module.exports = function^(^) {
    echo	var app = express^(^);
    echo	app.use^(express.static^("./public"^)^);
    echo	app.set^("views", "./app/views"^);
	echo	app.set^("view engine", "ejs"^);
	echo	require^("../app/routes/index.server.routes.js"^)^(app^);
	echo	require^("../app/routes/notfound.server.routes.js"^)^(app^);
    echo	return app;
	echo };
	echo.
)>>config/express.js
echo Configured express..
echo.

rem server.js
rem =========
(
    echo var port=3079;
    echo.
	echo var express=require^("./config/express"^);
	echo var app=express^(^);
	echo.
	echo app.listen^(port^);
    echo module.exports = app;
	echo console.log^("Server running at http://localhost:" + port^);
)>>server.js
echo Configured server setings..
echo.

call :colorEcho 0b "======================================================="
echo.
echo Your project is ready!
call :colorEcho 0b "======================================================="
echo.
pause>nul
goto :main

rem ==================================================
rem function to echo in different colors
rem ==================================================
:colorEcho
echo off
<nul set /p ".=%DEL%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1i
