#! /bin/bash

source install_lib.sh

version=$(get_json_var $(curret_path)/config.json version)
script_folder=$(get_json_var $(curret_path)/config.json script_folder)
log_folder=$(get_json_var $(curret_path)/config.json log_folder)

toilet -F metal "Installer v0.1"

LaunchScriptsFromFolder $script_folder $log_folder
