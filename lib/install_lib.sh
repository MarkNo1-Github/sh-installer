#! /bin/bash

source json_lib.sh


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


# function InstallScriptsFromConfigFile() {  CONFIG_PATH=$1; script_folder=$2; logs_folder=$3
#   TOOLS_NUMBER=$(get_lib_counter $CONFIG_PATH)
#   echo "Tools Selected: $TOOLS_NUMBER"
#
#   shopt -s nullglob
#   for (( i=0; i<TOOLS_NUMBER; i++ ))
#   do
#     LIBS_NAME=$(get_tool_number $CONFIG_PATH $i)
#     LIBS_PATH=$script_folder/$LIBS_NAME.sh
#
#     if [ -f "$LIBS_PATH" ]; then
#
#           LOG_FILE=$logs_folder/${LIBS_NAME/.sh/.log}
#
#           printf "[$TOOL_COUNTER/$TOOLS_NUMBER] Installing $LIBS_NAME  "
#           # Install Lib
#           InstallScript $LIBS_PATH $LOG_FILE
#           # Increment counter
#           ((TOOL_COUNTER+=1))
#     fi
#   done
# }

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
