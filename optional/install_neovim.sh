#!/bin/bash

INSTALL_CMD="$1"

if [[ -z "$INSTALL_CMD" ]]; then
  echo "Error: INSTALL_CMD not set. Exiting."
  exit 1
fi

echo "Installing Neovim..."

# Install Neovim if not installed
if ! command -v nvim &> /dev/null; then
  echo "Neovim not found. Installing..."
  eval "$INSTALL_CMD neovim"
else
  echo "Neovim already installed."
fi

# Install vim-plug for Neovim if missing
NVIM_AUTOLOAD_DIR="$HOME/.local/share/nvim/site/autoload"
PLUG_VIM="$NVIM_AUTOLOAD_DIR/plug.vim"

if [ ! -f "$PLUG_VIM" ]; then
  echo "Installing vim-plug for Neovim..."
  mkdir -p "$NVIM_AUTOLOAD_DIR"
  curl -fLo "$PLUG_VIM" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
else
  echo "vim-plug already installed for Neovim."
fi

# Create basic ~/.config/nvim if missing
if [ ! -d "$HOME/.config/nvim" ]; then
  echo "Creating default Neovim config directory..."
  mkdir -p "$HOME/.config/nvim"
fi

# Auto-run PlugInstall if init.vim exists
if [ -f "$HOME/.config/nvim/init.vim" ]; then
  echo "Running :PlugInstall to install Neovim plugins..."
  nvim --headless +PlugInstall +qa
else
  echo "No init.vim found. Skipping PlugInstall."
fi

echo "Neovim setup complete!"

