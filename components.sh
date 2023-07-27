#!/bin/zsh
################################################################################
# To use it please update the permissions to allow execution of the script
# chmod +x generators/components.sh
################################################################################
################################################################################
# Automatically generate a functional component for react                      #
# @usage ./generators/components.sh myComponent
################################################################################
################################################################################
# --help function
# @usage --help
# @description Display the list of available options
################################################################################
help() {
  echo "################################################################################"
  echo " 💻 Automatically generate a functional component for react 💻 "
  echo "################################################################################"
  echo ""
  echo "********************************************************************************"
  echo "To use this script, call it as follows:"
  echo "          ./components.sh [options]... [component]..."
  echo "********************************************************************************"
  echo ""
  echo "********************************************************************************"
  echo "Optional parameters"
  echo "  -e      Changes the extension of the created files to the one provided."
  echo "           Default value is ts."
  echo "  -d      Creates parent directory if they don't exist."
  echo "  -h   Call the help function."
  echo "********************************************************************************"
  echo ""
}
################################################################################
# generator function
# @description Generates the functional component for react
################################################################################
generate_functional_component() {
  style_extension="scss"
  component_extension="tsx"
  parent_directory="false"
  options_variable=1

  # Parsing options
  while getopts "h?d?e:" OPTION; do
    case "${OPTION}" in
      h|\?)
        help
        return
        ;;
      d)
        create_parents="true"
        ;;
      e)
        extension=${OPTARG}
        if [ $extension = "js" ]; then
          semicolon=""
        fi
        ;;
      : )
        echo "Invalid option: $OPTARG requires an argument" 1>&2
      ;;
    esac
  done
  # Shifting variable $1 from options to params
  shift $((options_variable-1))
  [ "${1:-}" = "--" ] && shift
  # Exit if no arguments!
  if [ $# -eq 0 ]; then
    echo "😟 No arguments supplied 😟"
    return 0
  fi
  # If the final directory doesn't exist function continues
  if [ -d $1 ]; then
    echo "😟 Directory already exists, I won't overwrite it 😟"
    return 0
  fi
  # Getting the path and name
  component_path="$@"
  component_name="`basename $component_path`"
  component_class="$(tr '[:lower:]' '[:upper:]' <<< ${component_name:0:1})${component_name:1}"
  # Preparing the data for the files
  component_data="import React from 'react'$semicolon
  import './$component_name.module.$style_extension'$semicolon

interface I${component_class}Props {
  children?: React.ReactNode
}

export const $component_class = (props: I${component_class}Props) => {
    return (
        <>
          <h2> {'Demo Component'} </h2>
          <h1> {'Switch to angular for more beautiful generators... - Bilal & Ali'} </h1>
        </>
    )$semicolon
}"
  # Checking if directory exists
  if [ ! -d $component_path ]; then
    # Creating the Directory
    if [ "$create_parents" = "true" ]; then
      mkdir --parents "${component_path}"
    else
      mkdir "${component_path}"
    fi

    # Creating files with the data arranged previously
    if [ -d $component_path ]; then
      touch "${component_path}/${component_name}.${component_extension}"
      touch "${component_path}/${component_name}.module.${style_extension}"
      echo $component_data > "${component_path}/${component_name}.${component_extension}"
      echo '' > "${component_path}/${component_name}.module.${style_extension}"
      echo "└ 💻 Function component $component_class created! 💻"
      echo "└ 🎨 Function component $component_class style created! 🎨"
      echo "└ 🥰 Running Prettier..."
      yarn prettier --write $component_path
      echo "🥳 Enjoy! 🎉"
    else
      # Errors creating the folders
        echo "  └ cannot create the folder."
      if [ "$create_parents" = "false" ]; then
        echo "    Use -p To also create parents folders."
      fi
      return 0
    fi
    return 0
  fi
}

generate_functional_component $*