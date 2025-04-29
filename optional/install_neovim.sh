#!/bin/bash

set -e

# Detect package manager
if command -v apt &>/dev/null; then
    PM="apt"
elif command -v pacman &>/dev/null; then
    PM="pacman"
elif command -v brew &>/dev/null; then
    PM="brew"
else
    echo "Unsupported package manager. Exiting."
    exit 1
fi

# Install Neovim depending on system
if [ "$PM" == "apt" ]; then
    echo "Downloading latest Neovim AppImage..."
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
    chmod u+x nvim.appimage
    ./nvim.appimage --appimage-extract > /dev/null
    sudo mv squashfs-root /opt/nvim
    sudo ln -sf /opt/nvim/AppRun /usr/local/bin/nvim
    rm nvim.appimage

elif [ "$PM" == "pacman" ]; then
    sudo pacman -Sy --noconfirm neovim
elif [ "$PM" == "brew" ]; then
    brew install neovim
fi

# Set up configuration if not already in place
mkdir -p ~/.config/nvim
if [ ! -f ~/.config/nvim/init.vim ]; then
    echo "set runtimepath^=~/.vim runtimepath+=~/.vim/after" > ~/.config/nvim/init.vim
    echo "let &packpath = &runtimepath" >> ~/.config/nvim/init.vim
    echo "source ~/.vimrc" >> ~/.config/nvim/init.vim
fi

# Optionally install vim-plug if using it
if grep -q 'Plug' ~/.vimrc 2>/dev/null; then
    echo "Installing vim-plug..."
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# Trigger plugin install if Plug is used
if grep -q 'Plug' ~/.vimrc 2>/dev/null; then
    echo "Launching Neovim to install plugins..."
    nvim +PlugInstall +qall
fi

echo "Neovim installation complete."

