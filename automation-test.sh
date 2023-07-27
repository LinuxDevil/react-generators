#!/bin/bash

# This script generates an automation test for a React page from a scenario text file.

# Check if a component name and scenario file were provided
if [ -z "$1" ] || [ -z "$2" ]
then
    echo "Please provide a component name and scenario file as arguments."
    exit 1
fi

# Set the component name and scenario file
component_name=$1
scenario_file=$2

# Set the path to the component file
component_path=src/pages/$component_name/$component_name.js

# Set the path to the test file
test_path=tests/$component_name.test.js

# Check if the component file exists
if [ ! -f $component_path ]
then
    echo "Component file not found at $component_path"
    exit 1
fi

# Check if the scenario file exists
if [ ! -f $scenario_file ]
then
    echo "Scenario file not found at $scenario_file"
    exit 1
fi

# Check if the test file already exists
if [ -f $test_path ]
then
    echo "Test file already exists at $test_path"
    exit 1
fi

# Create the test file
touch $test_path

# Add the test skeleton to the file
echo "import React from 'react';" >> $test_path
echo "import { render, fireEvent } from '@testing-library/react';" >> $test_path
echo "import $component_name from '../src/pages/$component_name/$component_name';" >> $test_path
echo "" >> $test_path
echo "describe('$component_name', () => {" >> $test_path

# Read the scenario file line by line
while IFS= read -r line
do
  # Split the line into parts
  read -ra parts <<< "$line"
  action=${parts[0]}
  element=${parts[1]}

  # Generate a test for the scenario step
  echo "  it('should $action when $element is clicked', () => {" >> $test_path
  echo "    const { getByText } = render(<$component_name />);" >> $test_path
  echo "    const element = getByText('$element');" >> $test_path
  echo "" >> $test_path
  echo "    fireEvent.click(element);" >> $test_path
  echo "" >> $test_path
  echo "    expect(element).toHaveTextContent('$action');" >> $test_path
  echo "  });" >> $test_path
  echo "" >> $test_path
done < "$scenario_file"

echo "});" >> $test_path

echo "Test file created at $test_path"
