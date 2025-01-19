#!/bin/bash

# Define dotfiles directory and JSON file
DOTFILES_DIR="$HOME/.dotfiles"
MAPPING_FILE="$DOTFILES_DIR/dotfiles.json"

# Ensure jq is installed
if ! command -v jq &> /dev/null; then
  echo "Error: jq is required to run this script. Please install jq and try again."
  exit 1
fi

# Determine the package manager based on the platform
if [[ "$OSTYPE" == "darwin"* ]]; then
  PLATFORM="macos"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  PLATFORM="linux"
else
  echo "Unsupported platform. Exiting."
  exit 1
fi

# Validate JSON file
if [ ! -f "$MAPPING_FILE" ]; then
  echo "Error: JSON configuration file $MAPPING_FILE not found."
  exit 1
fi

# Read platform-specific package manager commands
package_manager=$(jq -r ".platforms.$PLATFORM[]" "$MAPPING_FILE")

# Install packages, link dotfiles, and execute commands
echo "Installing packages, linking dotfiles, and executing commands..."

# Process packages from JSON
jq -c '.packages | to_entries[]' "$MAPPING_FILE" | while read -r entry; do
  package=$(echo "$entry" | jq -r '.key')
  install=$(echo "$entry" | jq -r '.value.install')
  dotfiles=$(echo "$entry" | jq -c '.value.dotfiles')
  commands=$(echo "$entry" | jq -c '.value.commands // []')

  if [[ "$install" == "true" ]]; then
    echo "Installing $package..."
    eval "$package_manager $package" &> /dev/null
  fi

  echo "$dotfiles" | jq -c '.[]' | while read -r dotfile; do
    source=$(echo "$dotfile" | jq -r '.source')
    target=$(echo "$dotfile" | jq -r '.target')
    SOURCE="$DOTFILES_DIR/$source"
    TARGET="$HOME/$target"

    # Ensure the parent directory of the target exists
    mkdir -p "$(dirname "$TARGET")"

    # Check if the source file exists
    if [ ! -e "$SOURCE" ]; then
      echo "Warning: $SOURCE does not exist. Skipping..."
      continue
    fi

    # Backup the existing target file, if it exists
    if [ -e "$TARGET" ]; then
      echo "Backing up $TARGET to $TARGET.bak"
      mv "$TARGET" "$TARGET.bak"
    fi

    # Create the symlink
    ln -s "$SOURCE" "$TARGET"
    echo "Linked $SOURCE -> $TARGET"
  done

  # Execute additional commands if any
  echo "$commands" | jq -r '.[]' | while read -r cmd; do
    echo "Executing command for $package: $cmd"
    eval "$cmd"
  done
done

echo "Setup complete!"

