# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a cutting-edge macOS developer setup automation repository (2026 Edition) designed for modern software engineering. It provides comprehensive, automated environment setup with parallel installation, modern tools (UV, Mise, Atuin, Zellij), SSH/GPG automation, and complete GitHub integration.

## Core Setup Commands

### **Main Setup Script**
```bash
chmod +x setup.sh
./setup.sh
```

**What it does (in order):**
1. **Bootstrap Phase** (sequential):
   - Installs Xcode Command Line Tools
   - Installs Homebrew

2. **Core Tools Phase** (parallel where possible):
   - Installs all Brewfile packages via `brew bundle`
   - Installs modern tools: UV, Mise, Atuin (parallel)
   - Installs AI tools: Claude Code, Open Code (parallel)

3. **Shell Setup**:
   - Installs Oh My Zsh
   - Symlinks dotfiles (`.zshrc`, `.aliases`, `.gitconfig`) to `$HOME`

4. **SSH/GPG & GitHub** (interactive):
   - Generates ED25519 SSH keys
   - Generates GPG keys for commit signing
   - Configures GitHub CLI authentication

5. **VS Code Extensions** (parallel):
   - Installs all extensions concurrently

6. **System Configuration**:
   - Applies macOS defaults (Finder, Dock, keyboard, trackpad)

**Key features:**
- ⚡ 3-5x faster through parallel installation
- 🎯 Real-time progress tracking ("Installing 3 of 12...")
- 🔄 Auto-retry on transient failures
- 🔐 Complete SSH/GPG automation
- 🎯 Cutting-edge autocompletion (Carapace, zsh-autosuggestions, fzf)
- ✅ Idempotent design (run multiple times safely)
- 📝 Detailed logs in `~/.setup-logs/`

**Brewfile Management:**
```bash
# Add a new package/cask to Brewfile and install
brew bundle --file=./Brewfile

# Dump current installed packages to Brewfile (if you want to capture new installs)
brew bundle dump --file=./Brewfile --force
```

**System Updates:**
```bash
# Update all Homebrew packages (aliased in .aliases)
brew update && brew upgrade && brew cleanup
# or use the alias:
update
```

## Architecture

### Dotfile Symlinking Strategy

The setup script creates symlinks from this repository's dotfiles to `$HOME`:
- `.zshrc` → `$HOME/.zshrc`
- `.aliases` → `$HOME/.aliases`
- `.gitconfig` → `$HOME/.gitconfig`

This allows version-controlled dotfile management. Existing files are backed up to `*.backup` before symlinking.

### Shell Configuration

**`.zshrc` initialization order:**
1. Oh My Zsh setup (minimal `robbyrussell` theme)
2. Starship prompt initialization (overrides OMZ theme)
3. **Mise** - unified version manager (replaces nvm/pyenv/rbenv)
4. **zoxide** - smart directory jumping with frecency
5. **Atuin** - magical shell history with SQLite backend
6. **UV** - Cargo environment for fast Python package management
7. Sources `.aliases`

**Modern CLI tool replacements** (in `.aliases` and Brewfile):
- `ls` → **eza** (icons, git status, tree view)
- `cat` → **bat** (syntax highlighting, git integration)
- `grep` → **ripgrep** (faster, respects .gitignore)
- `find` → **fd** (intuitive syntax, faster)
- `du` → **dust** (tree visualization)
- `ps` → **procs** (better output, search)
- `htop` → **btop** (graphs, mouse support)
- `cd` → **zoxide** (`z` command)
- `git diff` → **git-delta** (beautiful diffs)
- tmux → **zellij** (modern multiplexer)

### Git Configuration Philosophy

`.gitconfig` contains extensive git aliases designed for workflow efficiency:
- Single-letter shortcuts (`s`, `d`, `l`)
- Interactive history editing (`reb`, `di`)
- Pull request merging (`mpr`)
- Branch management (`go`, `dm`)

See `.gitconfig` lines 1-62 for full alias reference.

## Modifying the Setup

**Adding a new Homebrew package:**
1. Edit `Brewfile` - add `brew "package-name"` or `cask "app-name"`
2. Run `brew bundle --file=./Brewfile`

**Adding a new shell alias:**
1. Edit `.aliases`
2. Run `source ~/.zshrc` to reload (or use the `reload` alias)

**Adding a new VS Code extension:**
1. Edit `setup.sh` lines 86-95
2. Add `code --install-extension publisher.extension-name`

**Customizing macOS defaults:**
- Edit `setup.sh` in the `configure_macos()` function
- Run relevant `defaults write` commands manually or re-run setup script

## Modern Tools Usage

### **Mise - Unified Version Manager**
Replaces nvm, pyenv, rbenv, gvm, etc. with a single tool:
```bash
mise use --global node@20        # Install & use Node 20 globally
mise use --global python@3.12    # Install & use Python 3.12
mise install                      # Install all tools from .tool-versions
```

### **UV - Fast Python Package Manager**
10-100x faster than pip:
```bash
uv venv                          # Create virtual environment
uv pip install pandas            # Install package (blazing fast)
uv pip install -r requirements.txt
```

### **Atuin - Magical Shell History**
SQLite-backed, searchable, cross-machine synced:
```bash
atuin search                     # Interactive search (bound to Up arrow)
atuin search "git commit"        # Search for specific command
atuin sync                       # Sync across machines
```

### **Zellij - Modern Terminal Multiplexer**
Simpler than tmux, better defaults:
```bash
zellij                          # Start session
# Ctrl+p n - New pane
# Ctrl+p arrows - Switch panes
# Ctrl+t n - New tab
```

### **Rust CLI Tools**
```bash
eza -la --git                   # Modern ls with git status
bat file.txt                    # Syntax-highlighted cat
rg "pattern"                    # Fast grep (respects .gitignore)
fd "file"                       # Intuitive find
dust                            # Disk usage tree
procs                           # Better ps
btop                            # Beautiful system monitor
z project                       # Jump to frequent directory
```

## Important Notes

- **Backups:** Setup script backs up existing dotfiles to `*.backup`
- **Logs:** Detailed logs saved to `~/.setup-logs/setup-YYYYMMDD-HHMMSS.log`
- **Idempotent:** Run `setup-2026.sh` multiple times safely
- **SSH Keys:** ED25519 keys generated in `~/.ssh/id_ed25519`
- **GPG Keys:** Automatically configured for Git commit signing
- **Manual Steps:** Cursor IDE, Antigravity, and Raycast require post-setup installation
- **Git Status:** Many deleted files are legacy from original fork - expected during modernization
