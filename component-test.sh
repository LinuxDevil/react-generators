#!/bin/bash

# This script generates a Jest test file for a given React component.

# Check if a component name was provided
if [ -z "$1" ]
then
    echo "Please provide a component name as an argument."
    exit 1
fi

# Set the component name
component_name=$1

# Set the path to the component file
component_path=src/ui/components/$component_name/$component_name.tsx

# Check if the component file exists
if [ ! -f $component_path ]
then
    echo "Component file not found at $component_path"
    exit 1
fi

# Set the path to the test file
test_path=src/ui/components/$component_name/$component_name.spec.ts

# Check if the test file already exists
if [ -f $test_path ]
then
    echo "Test file already exists at $test_path"
    exit 1
fi

# Create the test file
touch $test_path

# Add the Jest imports to the test file
echo "import React from 'react';" >> $test_path
echo "import { render } from '@testing-library/react';" >> $test_path
echo "import $component_name from './$component_name';" >> $test_path

# Add the test case to the test file
echo "test('renders $component_name component', () => {" >> $test_path
echo "  const { getByText } = render(<$component_name />);" >> $test_path
ech " /**
        it('changes the class when hovered', () => {
           const component = renderer.create(
             <Link page="http://www.facebook.com">Facebook</Link>,
           );
           let tree = component.toJSON();
           expect(tree).toMatchSnapshot();

           // manually trigger the callback
           renderer.act(() => {
             tree.props.onMouseEnter();
           });
           // re-rendering
           tree = component.toJSON();
           expect(tree).toMatchSnapshot();

           // manually trigger the callback
           renderer.act(() => {
             tree.props.onMouseLeave();
           });
           // re-rendering
           tree = component.toJSON();
           expect(tree).toMatchSnapshot();
         });
**/" >> $test_path
echo "  const linkElement = getByText(/Hello $component_name/i);" >> $test_path
echo "  expect(linkElement).toBeInTheDocument();" >> $test_path
echo "});" >> $test_path

echo "Test file created at $test_path"
echo "└ 🥰 Running Prettier..."
yarn prettier --write $component_path
echo "🥳 Enjoy! 🎉"
