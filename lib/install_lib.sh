#! /bin/bash

source lib/json_lib.sh

function get_profile_path () { path=$1 ; profile=$2
  if [ -z "$profile" ]; then
      profile="all.json"
  fi

  echo "${path}/profiles/$profile"
}

function get_version () { profile_path=$1
  echo $(get_json_var $profile_path version)
}

function get_script_folder () { profile_path=$1
  echo $(get_json_var $profile_path script_folder)
}

function get_log_folder () { profile_path=$1
  echo $(get_json_var $profile_path log_folder)
}


function curret_path () {
  echo "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
}

function check_toilet () {
  if [ -z `which toilet` ]; then  echo "0"; fi
}

function install_toilet () {
  sudo apt install toilet
}

# Spinner Function
function Spinner(){ target_pid=$1
  sp='/-\|'
  while [ true ]; do
      printf '\b%.1s' "$sp"
      sp=${sp#?}${sp%???}
      if [ -d "/proc/${target_pid}" ]; then
        sleep 0.10
      else
        exit 0
      fi
  done
}


# Run a script, check the output and save the log
function Run() { script_path=$1; log_path=$2
  if  $script_path  > $log_path 2>&1  ; then
      echo -ne " \e[92mDone\e[0m"
  else
     echo -ne " \e[91mError ${log_path} \e[0m"
  fi
}


# Start a Run in a process, timeit and show a spinner for the complete running time.
function Launch() { script_path=$1 ; log_path=$2
  start=`date +%s`

  Run $script_path $log_path &

  pid=$!
  Spinner $pid &
  wait $pid 2>/dev/null
  end=`date +%s`
  printf " [`expr $end - $start` sec]\n"
}


function get_script_n () { profile_path=$1
  echo $(get_json_var_length $profile_path scripts)
}

function get_script_at () { profile_path=$1; idx=$2
  var="scripts[$idx]"
  echo $(get_json_var $profile_path "$var")
}


function InstallScriptsFromProfile() {  profile_path=$1; script_folder=$2; logs_folder=$3

  # Total number of scripts
  total_scripts=$(get_script_n $profile_path)
  # Create logs folde if not exist
  mkdir -p "$logs_folder"

  for (( i=0; i<total_scripts; i++ )); do

    script_name=$(get_script_at $profile_path "$i")
    script_path=$script_folder/$script_name

    if [ -f "$script_path" ]; then
          log_file=$logs_folder/${script_name/.sh/.log}

          printf "[$i/$total_scripts] launching $script_name   "
          Launch $script_path $log_file
    else
      echo "$script_path dosen't exist !!! "
    fi

  done
}

# Install all script inside target folder ending with .sh
function LaunchScriptsFromFolder() { script_folder=$1; logs_folder=$2
  shopt -s nullglob
  # Total number of scripts
  script_total=$(ls $script_folder | wc -l)
  # Create logs folde if not exist
  mkdir -p $logs_folder
  # Script counter
  script_counter=0

  for script in $script_folder/*.sh; do
    ((script_counter+=1))
    script_name=$(basename $script)
    log_file=$logs_folder/${script_name/.sh/.log}
    printf "[$script_counter/$script_total] launching $script_name   "

    Launch $script $log_file

  done
}
