#! /bin/bash

# Get var name
function get_json_var(){ file=$1 ; var=$2
  echo  $(jq ".$var" $file) | tr -d '"'
}

# Get var lenght
function get_json_var_length(){ file=$1 ; var=$2
  echo $(jq ".$var | length" $file)
}

# Get item on array at index
function get_json_array_item() { file=$1 ; var=$2 ; idx=$3
  echo $(get_json_var $file '$var[$idx]')
}
