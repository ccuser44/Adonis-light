#!/bin/sh

printf "Updating Roblox standard library"
selene generate-roblox-std

printf "Checking for lint errors from ./Loader and ./MainModule"
selene ./Loader ./MainModule

printf "Building Adonis place file"
rojo build -o Adonis.rbxl

printf "Building Adonis Standalone"
rojo build -o Adonis_Model.rbxm .github/build.project.json

printf "Set DebugMode off"
sed -i "s/DebugMode = true/DebugMode = false/g" Loader/Loader/Loader.server.luau

printf "Set NightlyMode off"
sed -i "s/NightlyMode = true/NightlyMode = false/g" Loader/Loader/Loader.server.luau

printf "Building Adonis Loader"
rojo build -o Adonis_Loader.rbxm .github/loader.deploy.project.json

printf "Building Adonis MainModule"
rojo build -o Adonis_MainModule.rbxm .github/module.deploy.project.json
