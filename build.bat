@echo off
SETLOCAL

where selene >nul 2>nul
IF %ERRORLEVEL% NEQ 0 (
	SET SELENE_COMMAND=.\selene.exe
) ELSE (
	SET SELENE_COMMAND=selene
)

where rojo >nul 2>nul
IF %ERRORLEVEL% NEQ 0 (
	SET ROJO_COMMAND=.\rojo.exe
) ELSE (
	SET ROJO_COMMAND=rojo
)

echo Updating Roblox standard library
selene generate-roblox-std

echo Checking for lint errors with %SELENE_COMMAND% from ./Loader and ./MainModule 
%SELENE_COMMAND% ./MainModule ./Loader

echo Using %ROJO_COMMAND% for rojo

echo Building Adonis place file
rojo build -o Adonis.rbxl

echo Building Adonis Standalone
rojo build -o Adonis_Model.rbxm .github/build.project.json

:: TODO: Make this use raw bat instead of powershell
echo Set DebugMode off
powershell -Command "(gc Loader/Loader/Loader.server.luau) -replace 'DebugMode = true', 'DebugMode = false' | Out-File -encoding ASCII Loader/Loader/Loader.server.luau"

:: TODO: Make this use raw bat instead of powershell
echo Set NightlyMode off
powershell -Command "(gc Loader/Loader/Loader.server.luau) -replace 'NightlyMode = true', 'NightlyMode = false' | Out-File -encoding ASCII Loader/Loader/Loader.server.luau"

echo Building Adonis Loader
rojo build -o Adonis_Loader.rbxm .github/loader.deploy.project.json

echo Building Adonis MainModule
rojo build -o Adonis_MainModule.rbxm .github/module.deploy.project.json

ENDLOCAL
