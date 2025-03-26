# React Native Project Setup Script

This script automates the process of creating a new React Native project. It allows you to select various project configurations such as the project name, React Native version, package manager, and additional tools like ESLint, Prettier, Jest, Husky, and GitHub Actions. The script also gives you the option to use TypeScript, set up an `.env` file, and configure the project's license and privacy status.

## Features

- **Node.js and npx Check**: The script checks if Node.js and `npx` are installed on your system before proceeding.
- **Project Configuration**: You can configure the project name, React Native version, and whether to use Expo or React Native CLI.
- **TypeScript Support**: Choose whether to use TypeScript for the project.
- **Package Manager Selection**: Choose between Yarn (recommended) or npm as your package manager.
- **License Selection**: Choose from several open-source licenses (MIT, Apache-2.0, GPL-3.0) or provide a custom license.
- **Privacy Settings**: Define whether the project is private or public.
- **ESLint, Prettier, Jest, Husky**: The script sets up ESLint for code linting, Prettier for code formatting, Jest for testing, and Husky for Git hooks.
- **GitHub Actions**: Automatically sets up a GitHub Actions workflow to run tests on the `main` branch.
- **.env Setup**: Optionally set up an `.env` file for environment variables.

## Setup Instructions

### Prerequisites

Ensure that the following tools are installed on your system:

- [Node.js](https://nodejs.org/)
- `npx` (comes with Node.js)

### How to Use

1. Clone or download the script to your local machine (npm i -g react-native-init-script).
2. Open a terminal or command prompt in the directory where the script is located.
3. Run the script with:

   ```bash
   ./react-native-init-script.sh
   ```

### MIT License

Copyright (c) 2025 itorron99

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
