#!/bin/bash

DOTFILES_DIR="$HOME/.dotfiles"
MAPPING_FILE="$DOTFILES_DIR/dotfiles.json"

if ! command -v jq &> /dev/null; then
  echo "Error: jq is required but not installed."
  exit 1
fi

jq -c '.packages | to_entries[]' "$MAPPING_FILE" | while read -r entry; do
  echo "$entry" | jq -c '.value.dotfiles[]' | while read -r dotfile; do
    source=$(echo "$dotfile" | jq -r '.source')
    target=$(echo "$dotfile" | jq -r '.target')

    SOURCE_FILE="$DOTFILES_DIR/$source"
    TARGET_FILE="$HOME/$target"

    # Ensure directory structure exists for source
    mkdir -p "$(dirname "$SOURCE_FILE")"

    if [ -L "$TARGET_FILE" ]; then
      echo "Symlink exists for $TARGET_FILE — skipping."
      continue
    elif [ -f "$TARGET_FILE" ]; then
      echo "Backing up $TARGET_FILE -> $TARGET_FILE.bak"
      mv "$TARGET_FILE" "$TARGET_FILE.bak"
      echo "Moving $TARGET_FILE.bak -> $SOURCE_FILE"
      mv "$TARGET_FILE.bak" "$SOURCE_FILE"
      ln -s "$SOURCE_FILE" "$TARGET_FILE"
      echo "Created symlink: $TARGET_FILE -> $SOURCE_FILE"
    else
      echo "Target $TARGET_FILE does not exist — skipping."
    fi
  done
done

echo "Dotfile update complete."

