#!/bin/bash

# === Setup Dotfiles Script ===
# Dynamically links dotfiles based on the contents of the dotfiles directory

DOTFILES_DIR="$HOME/.dotfiles/dotfiles"

echo "Scanning dotfiles directory: $DOTFILES_DIR"

# Create .config if missing
mkdir -p "$HOME/.config"

# Helper: safely backup files or directories
backup_if_exists() {
  local path="$1"
  if [ -e "$path" ] || [ -L "$path" ]; then
    local backup_path="${path}.bak"
    local counter=1
    while [ -e "$backup_path" ] || [ -L "$backup_path" ]; do
      backup_path="${path}.bak-${counter}"
      ((counter++))
    done
    echo "Backing up $path -> $backup_path"
    mv "$path" "$backup_path"
  fi
}

# First handle all top-level files and folders
find "$DOTFILES_DIR" -mindepth 1 -maxdepth 1 | while read -r source; do
  rel_path="${source#$DOTFILES_DIR/}"
  target="$HOME/$rel_path"

  # Ensure the parent directory exists
  mkdir -p "$(dirname "$target")"

  # Handle folders and files differently
  if [ -d "$source" ]; then
    echo "Processing directory: $source"
    backup_if_exists "$target"
    ln -s "$source" "$target"
    echo "Linked directory $source -> $target"
  elif [ -f "$source" ]; then
    echo "Processing file: $source"
    backup_if_exists "$target"
    ln -s "$source" "$target"
    echo "Linked file $source -> $target"
  fi
done

echo "Dotfiles setup complete."

