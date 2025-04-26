#!/bin/bash

# === Bootstrap Script ===
# Sets up basic applications, dotfiles, optional and system-specific installs

# Colors for terminal output
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RESET="\033[0m"

# Helper function for prompts
prompt_continue() {
  read -p $'\nPress ENTER to continue...' dummy
}

# Helper function for checklist menu
checklist_menu() {
  local options_file="$1"
  local base_dir="$2"

  [ -f "$options_file" ] || { echo -e "${YELLOW}Warning: $options_file not found. Skipping.${RESET}"; return; }

  local selected=()
  local index=1

  while IFS='|' read -r description script_name; do
    [ -z "$description" ] && continue
    echo "$index) $description"
    options[$index]="$base_dir/$script_name"
    ((index++))
  done < "$options_file"

  echo "0) Done selecting"

  while true; do
    read -p $'\nSelect an option (or 0 to continue): ' choice

    if [[ "$choice" == "0" ]]; then
      break
    elif [[ "$choice" -ge 1 && "$choice" -lt "$index" ]]; then
      selected+=("${options[$choice]}")
      echo "Queued: ${options[$choice]}"
    else
      echo -e "${YELLOW}Invalid choice. Try again.${RESET}"
    fi
  done

  for script in "${selected[@]}"; do
    echo -e "Running: $script"
    bash "$script" "$INSTALL_CMD"
  done
}

# Detect OS and set INSTALL_CMD
OS_TYPE="unknown"
INSTALL_CMD=""

if grep -q Microsoft /proc/version 2>/dev/null; then
  OS_TYPE="wsl"
elif [[ "$OSTYPE" == "msys"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
  OS_TYPE="gitbash"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  OS_TYPE="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  OS_TYPE="macos"
fi

case "$OS_TYPE" in
  linux|wsl)
    if command -v apt &> /dev/null; then
      INSTALL_CMD="sudo apt install -y"
    elif command -v pacman &> /dev/null; then
      INSTALL_CMD="sudo pacman -Syu --noconfirm"
    fi
    ;;
  macos)
    INSTALL_CMD="brew install"
    ;;
  gitbash)
    INSTALL_CMD="choco install -y"
    ;;
  *)
    echo -e "${YELLOW}Unsupported or unknown OS detected. Some features may not work.${RESET}"
    ;;
esac

# === Part 1: Install Basics ===
echo -e "${YELLOW}Installing basic applications...${RESET}"
bash scripts/install_basic_apps.sh "$INSTALL_CMD"

# === Part 2: Setup Dotfiles ===
echo -e "${YELLOW}Setting up dotfiles...${RESET}"
bash scripts/setup_dotfiles.sh

# === Part 3: Optional Installations ===
echo -e "${GREEN}Optional Installations Menu${RESET}"
checklist_menu "optional/options.conf" "optional"

# === Part 4: System-Specific Installations ===
echo -e "${GREEN}System-Specific Installations Menu${RESET}"
case "$OS_TYPE" in
  linux|wsl)
    checklist_menu "system_specific/linux_options.conf" "system_specific"
    ;;
  macos)
    checklist_menu "system_specific/macos_options.conf" "system_specific"
    ;;
  gitbash)
    checklist_menu "system_specific/windows_options.conf" "system_specific"
    ;;
  *)
    echo -e "${YELLOW}No system-specific options available.${RESET}"
    ;;
esac

echo -e "${GREEN}Bootstrap complete!${RESET}"

