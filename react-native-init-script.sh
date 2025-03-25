#!/bin/bash

# Check if Node.js and npx are installed
if ! command -v node &> /dev/null; then
  echo "❌ Node.js is not installed. Please install it first."
  sleep 50
  exit 1
fi

if ! command -v npx &> /dev/null; then
  echo "❌ npx is not available. Make sure you have Node.js installed correctly."
  sleep 50
  exit 1
fi

# Ask for the project name
while true; do
  read -p "📌 Enter the project name: " PROJECT_NAME
  echo ""
  if [ -z "$PROJECT_NAME" ]; then
    echo "❌ You must provide a project name."
  else
    break
  fi
done

# Ask for React Native version (only 0.74 or later)
while true; do
  read -p "🔹 Enter React Native version (must be 0.74 or later, leave empty for latest): " RN_VERSION
  echo ""
  if [ -z "$RN_VERSION" ]; then
    RN_VERSION="latest"
    break
  elif [[ "$RN_VERSION" =~ ^0\.(7[4-9]|[8-9][0-9]|[1-9][0-9]{2,}) ]]; then
    break
  else
    echo "❌ Invalid version. Please enter 0.74 or later."
  fi
done

# Choose between Expo or React Native CLI
while true; do
  echo "🔹 Choose an option:"
  echo "1) Expo (recommended for quick projects without native configuration)"
  echo "2) React Native CLI (needed for native code development)"
  read -p "👉 Option (1 or 2): " OPTION
  echo ""

  if [[ "$OPTION" == "1" || "$OPTION" == "2" ]]; then
    break
  else
    echo "❌ Invalid option. Please choose 1 or 2."
  fi
done

# Choose between JavaScript or TypeScript
while true; do
  echo "🔹 Do you want to use TypeScript?"
  read -p "👉 Type 'y' for yes or 'n' for no: " USE_TS
  echo ""

  if [[ "$USE_TS" == "y" || "$USE_TS" == "n" ]]; then
    break
  else
    echo "❌ Invalid input. Please type 'y' for yes or 'n' for no."
  fi
done

# Ask for package manager
while true; do
  echo "🔹 Choose a package manager:"
  echo "1) Yarn (recommended)"
  echo "2) npm"
  read -p "👉 Option (1 or 2): " PKG_MANAGER
  echo ""

  if [[ "$PKG_MANAGER" == "1" || "$PKG_MANAGER" == "2" ]]; then
    break
  else
    echo "❌ Invalid option. Please choose 1 or 2."
  fi
done

if [[ "$PKG_MANAGER" == "1" ]]; then
  PKG_CMD="yarn"
  INSTALL_CMD="yarn add"
  DEV_INSTALL_CMD="yarn add -D"
else
  PKG_CMD="npm"
  INSTALL_CMD="npm install"
  DEV_INSTALL_CMD="npm install --save-dev"
fi

# Ask for license
while true; do
  echo "🔹 Choose a license:"
  echo "1) MIT"
  echo "2) Apache-2.0"
  echo "3) GPL-3.0"
  echo "4) Custom"
  read -p "👉 Option (1-4): " LICENSE_OPTION
  echo ""

  if [[ "$LICENSE_OPTION" == "1" || "$LICENSE_OPTION" == "2" || "$LICENSE_OPTION" == "3" || "$LICENSE_OPTION" == "4" ]]; then
    break
  else
    echo "❌ Invalid option. Please choose 1, 2, 3, or 4."
  fi
done

case "$LICENSE_OPTION" in
  1) LICENSE="MIT" ;;
  2) LICENSE="Apache-2.0" ;;
  3) LICENSE="GPL-3.0" ;;
  4) read -p "👉 Enter custom license: " LICENSE ;;
esac

# Ask if project is private
while true; do
  read -p "🔹 Is this project private? (y/n): " IS_PRIVATE
  PRIVATE_FLAG="false"
  echo ""
  if [[ "$IS_PRIVATE" == "y" ]]; then
    PRIVATE_FLAG="true"
    break
  elif [[ "$IS_PRIVATE" == "n" ]]; then
    break
  else
    echo "❌ Invalid input. Please type 'y' for yes or 'n' for no."
  fi
done

# Ask if .env file should be set up
while true; do
  read -p "🔹 Do you want to set up an .env environment? (y/n): " SETUP_ENV
  echo ""
  if [[ "$SETUP_ENV" == "y" || "$SETUP_ENV" == "n" ]]; then
    break
  else
    echo "❌ Invalid input. Please type 'y' for yes or 'n' for no."
  fi
done

# Create the project
if [ "$OPTION" == "1" ]; then
  echo "🚀 Creating project with Expo..."
  npx create-expo-app "$PROJECT_NAME"
else
  echo "🚀 Creating project with React Native CLI (version: $RN_VERSION)..."
  npx @react-native-community/cli@${RN_VERSION} init "$PROJECT_NAME"
fi

cd "$PROJECT_NAME" || { echo "❌ Failed to navigate to project directory"; sleep 50; exit 1; }

# Configure TypeScript or JavaScript settings
if [[ "$USE_TS" == "y" ]]; then
  cat > tsconfig.json <<EOL
{
  "compilerOptions": {
    "target": "esnext",
    "moduleResolution": "node",
    "strict": true,
    "jsx": "react-native",
    "skipLibCheck": true
  }
}
EOL
  echo "📦 Installing TypeScript dependencies..."
  $DEV_INSTALL_CMD typescript @types/react @types/react-native || { echo "❌ Failed to install TypeScript dependencies"; sleep 50; exit 1; }
else
  cat > jsconfig.json <<EOL
{
  "compilerOptions": {
    "target": "esnext",
    "moduleResolution": "node",
    "jsx": "react-native"
  }
}
EOL
fi

# Install ESLint, Prettier, Jest, Husky, Import Sorting
echo "📦 Installing ESLint, Prettier, Jest, Husky & Import Sorting..."
$DEV_INSTALL_CMD eslint prettier eslint-config-prettier eslint-plugin-prettier jest @testing-library/react-native @types/jest husky lint-staged eslint-plugin-import eslint-plugin-unused-imports || { echo "❌ Failed to install dependencies"; sleep 50; exit 1; }

# Configure ESLint
cat > .eslintrc.json <<EOL
{
  "extends": ["eslint:recommended", "plugin:react/recommended", "plugin:prettier/recommended"],
  "plugins": ["react", "prettier", "import", "unused-imports"],
  "rules": {
    "prettier/prettier": "error",
    "import/order": [
      "error",
      {
        "groups": ["builtin", "external", "internal", "parent", "sibling", "index"],
        "newlines-between": "always"
      }
    ],
    "unused-imports/no-unused-imports": "error",
    "no-unused-vars": ["warn"]
  }
}
EOL

# Configure Prettier
cat > .prettierrc <<EOL
{
  "arrowParens": "avoid",
  "bracketSameLine": true,
  "bracketSpacing": true,
  "singleQuote": true,
  "trailingComma": "all",
  "printWidth": 100,
  "tabWidth": 2
}
EOL

# Configure Jest
cat > jest.config.js <<EOL
module.exports = {
  preset: "react-native",
  setupFilesAfterEnv: ["@testing-library/react-native/cleanup-after-each"],
};
EOL

# Setup Husky
mkdir -p .husky
cat > .husky/pre-commit <<EOL
#!/bin/sh
. "$(dirname -- "\$0")/_/husky.sh"

$PKG_CMD lint-staged
EOL
chmod +x .husky/pre-commit

cat > .lintstagedrc.json <<EOL
{
  "*.js": ["eslint --fix", "prettier --write"],
  "*.ts": ["eslint --fix", "prettier --write"]
}
EOL

# Setup GitHub Actions
mkdir -p .github/workflows
cat > .github/workflows/run-tests.yml <<EOL
name: Run Tests on Push to Main

on:
  push:
    branches:
      - main
    paths:
      - "src/**"

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Set up Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 18
          cache: $PKG_CMD

      - name: Install dependencies
        run: $PKG_CMD install --frozen-lockfile

      - name: Run tests
        run: $PKG_CMD test
EOL

# Create .gitignore
cat > .gitignore <<EOL
node_modules/
dist/
build/
.expo/
.idea/
.vscode/
.DS_Store
.env
EOL

# Create .env if requested
if [[ "$SETUP_ENV" == "y" ]]; then
  cat > .env <<EOL
# Add your environment variables here
API_URL=https://example.com
EOL
fi

echo "✅ Project $PROJECT_NAME successfully created with:"
echo "✅ React Native version: $RN_VERSION"
echo "✅ License: $LICENSE"
echo "✅ Package Manager: $PKG_CMD"
echo "✅ ESLint, Prettier, Jest, Husky, GitHub Actions"
if [[ "$SETUP_ENV" == "y" ]]; then
echo "✅ .env setup: $SETUP_ENV"
fi
