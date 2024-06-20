#!/usr/bin/env bash

declare -A venv_dict
venv_dir=~/env/pyVenv/

create_dict() {
  venv_dict=()

  for dir_path in "$venv_dir"/*/; do
    dir_name=$(basename "$dir_path")
    activate_path="$dir_path/bin/activate"

    if [[ -f "$activate_path" ]]; then
      venv_dict["$dir_name"]=$activate_path
    fi
  done
  
  echo "Found ${#venv_dict[@]} virtual environments."
}

source_venv() {

  if [[ ${#venv_dict[@]} -eq 0 ]]; then
    echo "No virtual environments found. Please run 'create_dict' first."
    return
  fi

  venv_names=("${!venv_dict[@]}")

  selected_venv=$(printf '%s\n' "${venv_names[@]}" | fzf)

  if [[ -n "$selected_venv" ]]; then
    activate_path="${venv_dict[$selected_venv]}"

    if [[ -f "$activate_path" ]]; then

      source "$activate_path"

    else
      echo "Error: Activation script not found for virtual environment $selected_venv"
    fi
  else
    echo "No virtual environment selected."
  fi
}

create_dict

source_venv

