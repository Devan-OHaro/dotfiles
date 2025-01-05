#!/bin/bash

DOTFILES_DIR="$(pwd)"
echo "Dotfiles directory: $DOTFILES_DIR"

# Test symlink creation
SOURCE="$DOTFILES_DIR/vimrc"
TARGET="$HOME/.vimrc"

if [ ! -e "$SOURCE" ]; then
  echo "Source $SOURCE does not exist."
  exit 1
fi

if [ -e "$TARGET" ]; then
  echo "Backing up $TARGET to $TARGET.bak"
  mv "$TARGET" "$TARGET.bak"
fi

ln -s "$SOURCE" "$TARGET"
echo "Linked $SOURCE -> $TARGET"

