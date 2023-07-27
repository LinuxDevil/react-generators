# Bash Generators

This repository contains a series of Bash scripts aimed at automating various tasks related to test generation, page creation, and component creation in TypeScript and React applications.

## Scripts

Here is a brief description of each script:

- `automation-test.sh`: This script generates an automation test for a React page from a scenario text file.

- `class-test.sh`: This script generates a test file for a TypeScript class and its functions.

- `component-test.sh`: This script generates a Jest test file for a given React component.

- `components.sh`: This script automatically generates a functional component for React.

- `mock-test.sh`: This script automatically generates a mock test for a given TypeScript file.

- `page.sh`: This script automatically generates a page & service for React.

## How to Use

All scripts are designed to be run from the command line. Here's an example of how to use them:

#### Generating components inside the project

```bash
./generators/component.sh <component_location>/<component_name>
# Example
./generators/component.sh src/ui/components/Header
```

#### Generating pages inside the project

```bash
./generators/component.sh <page_name>
# Example
./generators/component.sh home
```

## Requirements

- Bash environment (use Git Bash on Windows)
- Node.js
- React
- Jest

## Contributing

Contributions are welcome. Please fork this repository and create a pull request if you have something useful to add.

## License

This project is licensed under the MIT License - see the LICENSE.md file for details.
