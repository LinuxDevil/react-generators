#!/bin/zsh
################################################################################
# To use it please update the permissions to allow execution of the script
# chmod +x generators/page.sh
################################################################################

################################################################################
# Automatically generate a functional component for react                      #
# @usage ./generators/page.sh MyPage
################################################################################
################################################################################
# --help function
# @usage --help
# @description Display the list of available options
################################################################################
help() {
  echo "################################################################################"
  echo " 😎 Automatically generate a page & service for react 😎 "
  echo "################################################################################"
  echo ""
  echo "********************************************************************************"
  echo "To use this script, call it as follows:"
  echo "          ./page.sh [options]... [component]..."
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
# @description Generates the page and a service for react
################################################################################
generate_page() {
  base_path="src/ui/screens/"
  style_extension="scss"
  page_extension="tsx"
  service_extension="service.ts"
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
  page_path="${base_path}$@"
  page_name="`basename $page_path`"
  service_name="${page_name}"
  page_class="$(tr '[:lower:]' '[:upper:]' <<< ${page_name:0:1})${page_name:1}"
  service_class="$(tr '[:lower:]' '[:upper:]' <<< ${service_name:0:1})${service_name:1}"
  service_data="import { ApiService } from '../../../services/Api.service'$semicolon
    export const ${service_class}Service = {
      getDemoData: async () => (await new ApiService().get<{ data: string }>('path')).data,
    }$semicolon
  "
  # Preparing the data for the files
  page_data="import React, { useState, useEffect } from 'react'$semicolon
  import './$page_class.$style_extension'$semicolon
  import { ${service_class}Service } from './services/${service_class}.service'$semicolon
  import { useTranslation } from 'react-i18next'$semicolon

  export const $page_class = () => {
    const [demo, setDemo] = useState<string>('')$semicolon

    /**
    * Demo function to api call
    */
    async function getDemoData() {
      const demoData = await ${service_class}Service.getDemoData()$semicolon
      setDemo(demoData)$semicolon
    }

    useEffect(() => {
      if (!demo) {
        void getDemoData()$semicolon
      }
    }, [])$semicolon

    return (
        <>
          <h2> Message from Bilal 😎 & Ali 🎨</h2>
          <h1> Switch to Angular for more beautiful generators... </h1>
        </>
    )$semicolon
}"
  # Checking if directory exists
  if [ ! -d $page_path ]; then
    # Creating the Directory
    if [ "$create_parents" = "true" ]; then
      mkdir --parents "${page_path}"
    else
      mkdir "${page_path}"
    fi
    # Creating files with the data arranged previously
    if [ -d $page_path ]; then
      touch "${page_path}/${page_class}.${page_extension}"
      touch "${page_path}/${page_class}.${style_extension}"
      mkdir "${page_path}/services"
      touch "${page_path}/services/${service_class}.${service_extension}"
      echo $page_data > "$page_path/$page_class.$page_extension"
      echo '' > "$page_path/$page_class.$style_extension"
      echo $service_data > "$page_path/services/$service_class.$service_extension"
      echo "└ 💻 Page $page_class created! 💻"
      echo "└ 🎨 Page $page_class style created! 🎨"
      echo "└ ⏳ Page $page_class service created! ⏳"
      echo "└ 🥰 Running Prettier..."
      yarn prettier --write $page_path
      echo "🥳 Enjoy! 🎉"
    else
      # Errors creating the folders
        echo "  └ cannot create the folder."
      if [ "$create_parents" = "false" ]; then
        echo "    Use -d To also create parents folders."
      fi
      return 0
    fi
    return 0
  fi
}

generate_page $*