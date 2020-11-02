#! /bin/bash

installer_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
[ "$UID" -eq 0 ] || exec sudo "$0" "$@"

source "$installer_path/lib/install_lib.sh"
source "$installer_path/lib/json_lib.sh"

clear
toilet -F metal "sh-instal"

get_profile_path $installer_path $1
PROFILE_PATH="$installer_path$PROFILE_PATH"

version=$(get_version $PROFILE_PATH)
script_folder=$(get_script_folder $PROFILE_PATH)
log_folder=$(get_log_folder $PROFILE_PATH)

echo -e "\nProfile:"
echo -e "\tVersion: $version"
echo -e "\tScripts folder: $script_folder"
echo -e "\tLog folder: $log_folder\n\n"

mkdir -p "$log_folder"

LaunchScriptsFromFolder $script_folder $log_folder
