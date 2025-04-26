# Dotfiles Repository

This repository contains my personal dotfiles for configuring development environments, managing tools, and customizing workflows. It includes a script to automate the installation of software and the setup of symbolic links for configuration files.

## Table of Contents
- [Installation](#installation)
- [Usage](#usage)
- [Adding or Modifying Dotfiles](#adding-or-modifying-dotfiles)
- [Repository Structure](#repository-structure)
- [Contributing](#contributing)

---

## Installation

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/Devan-OHaro/dotfiles.git ~/.dotfiles
   ```

2. **Install Dependencies:**
   Ensure you have `jq` installed:
   - **Ubuntu/Debian:**
     ```bash
     sudo apt install -y jq
     ```
   - **macOS:**
     ```bash
     brew install jq
     ```

3. **Run the Setup Script:**
   ```bash
   ~/.dotfiles/install.sh
   ```

---

## Usage

### Add New Dotfiles
1. Place the file in the appropriate directory inside `~/.dotfiles/`.
   - Example: `~/.dotfiles/nvim/init.vim` for Neovim.
2. Update the `dotfiles.json` file with the new configuration:
   ```json
   "neovim": {
     "install": true,
     "dotfiles": [
       { "source": "nvim/init.vim", "target": ".config/nvim/init.vim" }
     ]
   }
   ```

3. Re-run the setup script to apply the changes:
   ```bash
   ~/.dotfiles/install.sh
   ```

---

### Backup Existing Configurations
If existing configuration files are found, they are renamed with a `.bak` suffix before creating symlinks.

---

## Repository Structure

```plaintext
~/system-setup/
├── bootstrap.sh            # (the script you have now)
├── scripts/                 # Scripts that run automatically
│   ├── install_basic_apps.sh
│   ├── setup_dotfiles.sh
├── optional/                # Optional installs (user selects from menu)
│   ├── optional_options.conf
│   ├── install_neovim.sh
│   ├── install_chromium.sh
│   ├── install_yomitan_dictionaries.sh
├── system_specific/         # System-specific installs
│   ├── linux_options.conf
│   ├── macos_options.conf
│   ├── windows_options.conf
│   ├── install_linux_fonts.sh
│   ├── install_macos_homebrew.sh
│   ├── install_windows_terminal.sh
├── dotfiles/                # Your actual dotfiles
│   ├── .vimrc
│   ├── .zshrc
│   ├── .tmux.conf
│   └── nvim/
│       └── init.vim
├── configs/                 # Misc GUI configs (if needed later)
│   └── (empty for now)
└── README.md                # (eventually explaining how everything works)
```

---

## Contributing

### Tasks and TODOs
To manage tasks:
1. Use the `tasks/` directory to store notes or work to be done.
2. Organize tasks in individual markdown files:
   - Example: `tasks/setup-tmux.md` to detail work for tmux configuration.

### Git Workflow
1. Create a branch for each task:
   ```bash
   git checkout -b feature/update-neovim-config
   ```
2. Commit your changes:
   ```bash
   git add .
   git commit -m "Update Neovim configuration"
   ```
3. Push to GitHub:
   ```bash
   git push origin feature/update-neovim-config
   ```
4. Open a pull request for review.

---

## Future Work
- Add more detailed dotfiles for other tools.
- Explore platform-specific customizations.
- Automate additional setup steps like SSH keys, Git configurations, etc.

---

## Tasks Directory Example

### Create a `tasks/` Directory
Organize work to be done into markdown files.

#### Example:
- `tasks/setup-tmux.md`: Detail plans to enhance tmux configurations.
- `tasks/add-docker-config.md`: Outline plans for Docker-related configurations.
- `tasks/improve-install-script.md`: Track enhancements to the installation script.

### Git Workflow for Tasks
1. Create a task branch:
   ```bash
   git checkout -b task/task-name
   ```
2. Add your task markdown files:
   ```plaintext
   ~/.dotfiles/tasks/setup-tmux.md
   ```
3. Commit and push:
   ```bash
   git add tasks/
   git commit -m "Add setup-tmux task notes"
   git push origin task/task-name
   ```

