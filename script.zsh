#!/bin/zsh

# Variables
TEMPLATE_PATH="https://github.com/StewartEthan/parcel-react-boilerplate/raw/master/templates";

# Get options from command line
PORT_NUMBER=9000;
PROJECT_NAME=`basename \`pwd\``;
PROJECT_DESCRIPTION="";
while getopts "d:n:p:" opt; do
  case $opt in
    d)
      PROJECT_DESCRIPTION=$OPTARG
      ;;
    n)
      PROJECT_NAME=$OPTARG;
      ;;
    p)
      PORT_NUMBER=$OPTARG;
      ;;
  esac
done

# Create package.json
curl -fsSL "$TEMPLATE_PATH/package.json" \
| sed "s/PROJECT_NAME/$PROJECT_NAME/" \
| sed "s/PROJECT_DESCRIPTION/$PROJECT_DESCRIPTION/" \
| sed "s/PORT_NUMBER/$PORT_NUMBER/" \
> ./package.json;

# Prevent package-lock
echo "package-lock=false" > ./.npmrc;

# Install dependencies
npm i @emotion/core react react-dom prop-types;
npm i --save-dev @babel/core @emotion/babel-preset-css-prop eslint jest parcel-bundler github:StewartEthan/eslint-config-personal;

# Create base files
mkdir ./public ./src ./src/components;
curl -fsSL "$TEMPLATE_PATH/index.html" | sed "s/PROJECT_NAME/$PROJECT_NAME/" > ./public/index.html;
curl -fsSL "$TEMPLATE_PATH/index.js" > ./src/index.js;
curl -fsSL "$TEMPLATE_PATH/App.js" | sed "s/PROJECT_NAME/$PROJECT_NAME/" > ./src/components/App.js;

# Set up fix on save for VS Code
if [ ! -d ./.vscode ]; then
  mkdir ./.vscode;
fi
curl -fsSL "$TEMPLATE_PATH/vscode-settings.json" > ./.vscode/settings.json;

# Set up git
git init;
curl -fsSL "https://raw.githubusercontent.com/StewartEthan/dotfiles/master/.gitignore" > ./.gitignore;

# Open the new project
code .;
