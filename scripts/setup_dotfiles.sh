#!/bin/bash

# === Setup Dotfiles Script ===
# Dynamically links dotfiles based on the contents of the dotfiles directory

DOTFILES_DIR="$HOME/dotfiles/dotfiles"
SPECIAL_DIR="$DOTFILES_DIR/special"

echo "Scanning dotfiles directory: $DOTFILES_DIR"

# Create .config if missing
mkdir -p "$HOME/.config"

# Helper function to safely backup files
backup_if_exists() {
  local path="$1"
  
  if [ -L "$path" ]; then
    echo "Removing old symlink: $path"
    rm "$path"
  elif [ -f "$path" ]; then
    local backup_path="${path}.bak"
    local counter=1
    while [ -e "$backup_path" ] || [ -L "$backup_path" ]; do
      backup_path="${path}.bak-${counter}"
      ((counter++))
    done
    echo "Backing up existing file: $path -> $backup_path"
    mv "$path" "$backup_path"
  fi
}

# Handle normal dotfiles
find "$DOTFILES_DIR" -mindepth 1 -maxdepth 1 \( ! -name "special" \) | while read -r source; do
  rel_name="${source#$DOTFILES_DIR/}"

  if [[ "$rel_name" == .* ]]; then
    target="$HOME/$rel_name"
  else
    target="$HOME/.$rel_name"
  fi

  mkdir -p "$(dirname "$target")"

  backup_if_exists "$target"

  echo "Linking $source -> $target"
  ln -s "$source" "$target"
done

# Handle special dotfiles
if [ -d "$SPECIAL_DIR" ]; then
  echo "Scanning special cases directory: $SPECIAL_DIR"

  for target_file in "$SPECIAL_DIR"/*.target; do
    [ -e "$target_file" ] || continue

    filename="$(basename "$target_file" .target)"
    destination_path=$(cat "$target_file")
    source="$SPECIAL_DIR/$filename"
    target="$HOME/$destination_path"

    mkdir -p "$(dirname "$target")"

    backup_if_exists "$target"

    echo "Linking $source -> $target"
    ln -s "$source" "$target"
  done
fi

echo "Dotfiles setup complete."

