#!/bin/bash

declare -A venv_dict
venv_dir=~/env/pyVenv/

create_dict() {
  # Clear the associative array
  venv_dict=()

  # Iterate over the directories in venv_dir
  for dir_path in "$venv_dir"/*/; do
    dir_name=$(basename "$dir_path")
    activate_path="$dir_path/bin/activate"

    # Check if the activation script file exists
    if [[ -f "$activate_path" ]]; then
      venv_dict["$dir_name"]=$activate_path
    fi
  done
  
  # Debug: Print the number of virtual environments found
  echo "Found ${#venv_dict[@]} virtual environments."
}

source_venv() {
  # Check if the associative array is empty
  if [[ ${#venv_dict[@]} -eq 0 ]]; then
    echo "No virtual environments found. Please run 'create_dict' first."
    return
  fi

  # Get the virtual environment names as keys for fzf
  venv_names=("${!venv_dict[@]}")

  # Prompt the user to select a virtual environment using fzf
  selected_venv=$(printf '%s\n' "${venv_names[@]}" | fzf)

  if [[ -n "$selected_venv" ]]; then
    # Get the corresponding activation path from the associative array
    activate_path="${venv_dict[$selected_venv]}"

    # Check if the activation script file exists
    if [[ -f "$activate_path" ]]; then
      # Run the activation script
      source "$activate_path"
    else
      echo "Error: Activation script not found for virtual environment $selected_venv"
    fi
  else
    echo "No virtual environment selected."
  fi
}

# Create the dictionary in memory
create_dict

# Source the selected virtual environment
source_venv

