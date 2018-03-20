rem ==================================================
rem console view settings
rem ==================================================
@echo off
setlocal enabledelayedexpansion
rem echo in different colours
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do     rem"') do (
  set "DEL=%%a"
)
title ProjectSetup
mode con: cols=75 lines=30
color 0a

:main
cls
rem ==================================================
rem default path for all projects
rem ==================================================
cd /d %userprofile%/Desktop
if not exist backend md backend
cd /d %userprofile%/Desktop/backend

call :colorEcho 0b "======================================================="
echo.
echo WINDOWS WEB DEVELOPMENT PROJECT MANAGER BY REU
call :colorEcho 0b "======================================================="
echo.
echo New Project               :      -new
echo.
echo Run Project               :      -run projectName
echo.
echo Command Prompt            :      -cmd
echo.
echo Leave Command Prompt      :      -return
echo.
echo To Exit                   :      -exit
call :colorEcho 0b "======================================================="
echo.
echo.
set /p input=!userName! 
echo !input!|findstr /i /x "^-new" >nul && goto :newProject
echo !input!|findstr /i "^-run" >nul && goto :runApp
echo !input!|findstr /i /x "^-cmd" >nul && (echo. && goto :cmdPrompt)
echo !input!|findstr /i /x "^-exit" >nul && exit
echo.
goto :main

:cmdPrompt
set /p input=!cd!^>
echo !input!|findstr /i /x "^-return" >nul && goto :main
call !input!
echo.
goto :cmdPrompt

:runApp
echo.
cd !input:~5!
call node server.js
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
md !projectName: =!
cd !projectName: =!
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
call npm init
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
mkdir app && cd app
mkdir controllers models routes views
cd views
mkdir partials
cd ../..
mkdir config && cd config
mkdir env
cd ..
mkdir public && cd public
mkdir css img js
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
call npm install --save express ejs request !packages!
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
