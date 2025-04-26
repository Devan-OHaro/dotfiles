# System Setup Overview

This repository sets up your full system environment, including dotfiles, packages, and optional tools. It works modularly across **Linux**, **WSL**, **macOS**, and **Git Bash (Windows)**.

---

## 🔥 Quickstart

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/your-repo.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. **Run the bootstrap:**
   ```bash
   bash bootstrap.sh
   ```

3. **Follow the prompts** to install optional and system-specific tools.

---

## 🛠 Bootstrap Flow (All OS)

1. **Install Basic Applications**
   - Installs essential packages (git, curl, wget, jq).
   - Auto-detects your package manager (apt, pacman, brew, choco).

2. **Set up Dotfiles**
   - Links dotfiles from `dotfiles/` into `$HOME/`.
   - Handles special cases (`special/` folder) based on `.target` files.
   - Backs up real files (`.bak`), removes symlinks cleanly.

3. **Optional Installations**
   - Menu-driven install of optional tools (like Neovim, Chromium, Yomitan dictionaries).

4. **System-Specific Installations**
   - Extra setup depending on detected system:
     - `system_specific/linux_options.conf`
     - `system_specific/macos_options.conf`
     - `system_specific/windows_options.conf`

---

## 🧠 Per OS Details

### Linux (Ubuntu, Arch, etc.)
- Install basics using `apt` or `pacman`.
- Dotfiles linked under `$HOME`.
- Neovim and plugins set up.
- Fonts and Linux-specific tweaks available under `system_specific/`.

### WSL (Windows Subsystem for Linux)
- Treated like Linux.
- Bootstrap fully supported.
- Optional installs may skip GUI tools.

### macOS
- Install basics using `brew`.
- Dotfiles linked.
- macOS-specific options (Homebrew, GUI configs) available.

### Git Bash (Windows)
- Basic setup only.
- Installs via `choco` if available.
- Limited dotfile linking (no `$HOME/.config/` style configs).

---

## 📂 Directory Layout

```plaintext
.dotfiles/
├── bootstrap.sh
├── dotfiles/
│   ├── .vimrc
│   ├── .gitconfig
│   ├── special/
│   │   ├── init.vim
│   │   └── init.vim.target
├── scripts/
│   ├── install_basic_apps.sh
│   ├── setup_dotfiles.sh
├── optional/
│   ├── optional_options.conf
│   ├── install_neovim.sh
├── system_specific/
│   ├── linux_options.conf
│   ├── macos_options.conf
│   ├── windows_options.conf
```

---

## 📜 Notes
- You can **add more dotfiles** into `dotfiles/` anytime.
- You can **add more optional tools** easily by editing `optional/optional_options.conf`.
- System detection happens **automatically** — no manual setup needed.

---

## 🚀 Future Enhancements
- Dry-run preview mode.
- Auto-syncing dotfiles after manual changes.
- Better Windows full support via WSL or native Powershell wrappers.

---

**Happy hacking! 🛠**

