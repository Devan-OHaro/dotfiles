#!/bin/bash

# === Bootstrap Setup Script ===
# For Devan-OHaro's full environment setup

# Colors for clean output
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RESET="\033[0m"

# Helper function
prompt_continue() {
  read -p $'\nPress ENTER to continue...' dummy
}

# Install options
while true; do
  clear
  echo "${GREEN}=== System Bootstrap Menu ===${RESET}"
  echo "1) Install Basic Apps (git, curl, wget, jq)"
  echo "2) Set up Dotfiles (symlinks)"
  echo "3) Install Neovim and Vim-Plug"
  echo "4) Install Chromium + Yomitan Extension"
  echo "5) Install Fonts"
  echo "0) Exit"

  read -p $'\nChoose an option: ' choice

  case $choice in
    1)
      echo "${YELLOW}Installing basic applications...${RESET}"
      bash scripts/install_basic_apps.sh
      prompt_continue
      ;;
    2)
      echo "${YELLOW}Setting up dotfiles...${RESET}"
      bash scripts/setup_dotfiles.sh
      prompt_continue
      ;;
    3)
      echo "${YELLOW}Installing Neovim and Vim-Plug...${RESET}"
      bash scripts/install_neovim.sh
      prompt_continue
      ;;
    4)
      echo "${YELLOW}Installing Chromium and setting up Yomitan...${RESET}"
      bash scripts/install_chromium_yomitan.sh
      prompt_continue
      ;;
    5)
      echo "${YELLOW}Installing fonts...${RESET}"
      bash scripts/install_fonts.sh
      prompt_continue
      ;;
    0)
      echo "${GREEN}Exiting bootstrap script. Goodbye!${RESET}"
      exit 0
      ;;
    *)
      echo "${YELLOW}Invalid choice. Try again.${RESET}"
      sleep 2
      ;;
  esac

done
