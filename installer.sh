#! /bin/bash

source install_lib.sh

version=$(get_json_var $(curret_path)/configs/dev-tools.json version)
script_folder=$(curret_path)/dev-tools/
log_folder=$(get_json_var $(curret_path)/configs/dev-tools.json log_folder)

toilet -F metal "Installer v0.1"

LaunchScriptsFromFolder $script_folder $log_folder
