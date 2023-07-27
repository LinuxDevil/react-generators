#!/bin/bash
################################################################################
# To use it please update the permissions to allow execution of the script
# chmod +x generators/components.sh
################################################################################
################################################################################
# Automatically generate a mock test for a given ts file
# @usage ./generators/mock-test.sh [options]... [file]...
################################################################################
################################################################################

# Check if a TypeScript file has been provided as argument
if [ -z "$1" ]
then
    echo "Error: No TypeScript file provided"
    exit 1
fi

# Extract the filename without the extension
filename=$(basename "$1" .ts)

# Create a new mock test file with the same name as the original file, but with _mock_test appended to the filename
mock_test_file="${filename}_mock_test.ts"
touch "$mock_test_file"

# Extract the functions from the original file
functions=$(grep "^export function" "$1" | sed 's/export function //' | sed 's/(.*//')

# Write the mock test imports and describe block to the mock test file
echo "import { mocked } from 'ts-jest/utils';" >> "$mock_test_file"
echo "" >> "$mock_test_file"
echo "describe('$filename', () => {" >> "$mock_test_file"

# Iterate over the functions and write a mock test for each one
for function in $functions
do
    echo "    it('should mock $function', () => {" >> "$mock_test_file"
    echo "        const $function = mocked($function, true);" >> "$mock_test_file"
    echo "        expect($function).toHaveBeenCalled();" >> "$mock_test_file"
    echo "    });" >> "$mock_test_file"
    echo "" >> "$mock_test_file"
done

# Close the describe block
echo "});" >> "$mock_test_file"

echo "Mock tests for $filename written to $mock_test_file"
