#!/bin/bash

# This script generates a test file for a TypeScript class and its functions.

# Check if a class name was provided
if [ -z "$1" ]
then
    echo "Please provide a class name as an argument."
    exit 1
fi

# Set the class name
class_name=$1

# Set the path to the class file
class_path=src/classes/$class_name.ts

# Set the path to the test file
test_path=tests/$class_name.test.ts

# Check if the class file exists
if [ ! -f $class_path ]
then
    echo "Class file not found at $class_path"
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
echo "import { $class_name } from '../src/classes/$class_name';" >> $test_path
echo "" >> $test_path
echo "describe('$class_name', () => {" >> $test_path

# Extract the functions from the class file
functions=$(grep -oP "(?<=function ).*(?=\()" $class_path)

# Generate a test for each function
for function in $functions
do
  echo "  it('should do something', () => {" >> $test_path
  echo "    const myClass = new $class_name();" >> $test_path
  echo "    expect(myClass.$function()).toBe(true);" >> $test_path
  echo "  });" >> $test_path
  echo "" >> $test_path
done

echo "});" >> $test_path

echo "Test file created at $test_path"