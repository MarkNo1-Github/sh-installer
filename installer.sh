#! /bin/bash

installer_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
[ "$UID" -eq 0 ] || exec sudo "$0" "$@"

source "$installer_path/lib/install_lib.sh"
source "$installer_path/lib/json_lib.sh"

clear
toilet -F metal "sh-instal"

profile_path="$(get_profile_path $installer_path $1)"

version=$(get_version $profile_path)
scripts_folder="$installer_path/scripts"
log_folder=$(get_log_folder $profile_path)

echo -e "\nProfile:"
echo -e "\tPath: $profile_path"
echo -e "\tVersion: $version"
echo -e "\tLog folder: $log_folder\n\n"

# LaunchScriptsFromFolder $script_folder $log_folder
InstallScriptsFromProfile $profile_path $scripts_folder $log_folder
