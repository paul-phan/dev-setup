# Modern macOS Dev Setup (2026 Edition) 🚀

A comprehensive, cutting-edge automated developer setup for macOS with modern tools, parallel installation, and complete automation.

## Features ✨

### **Core Improvements (2026)**
*   ⚡ **Parallel Installation**: 3-5x faster setup through concurrent operations
*   🎯 **Progress Tracking**: Real-time progress indicators with time estimates
*   🔄 **Auto-Retry Logic**: Resilient against network failures with exponential backoff
*   🔐 **Complete Automation**: SSH/GPG keys + GitHub CLI authentication out-of-the-box
*   ✅ **Idempotent**: Run multiple times safely without side effects

### **Modern Tools Stack**
*   **Package Management**: [Homebrew](https://brew.sh/) with declarative `Brewfile`
*   **Shell**: Zsh + [Oh My Zsh](https://ohmyz.sh/) + [Starship](https://starship.rs/) prompt
*   **Version Management**: [Mise](https://mise.jdx.dev/) (unified Node/Python/Ruby/etc)
*   **Python**: [UV](https://github.com/astral-sh/uv) (10-100x faster than pip)
*   **Shell History**: [Atuin](https://atuin.sh/) (SQLite-backed, searchable, synced)
*   **Terminal Multiplexer**: [Zellij](https://zellij.dev/) (modern tmux alternative)

### **Rust CLI Tools** (Replacing Unix classics)
*   `eza` → modern `ls` with icons & git status
*   `bat` → modern `cat` with syntax highlighting
*   `ripgrep` → faster `grep` with smart defaults
*   `fd` → modern `find` with intuitive syntax
*   `dust` → modern `du` with tree visualization
*   `procs` → modern `ps` with better output
*   `zoxide` → smarter `cd` with frecency
*   `git-delta` → beautiful git diffs
*   `btop` → modern `htop` with graphs

### **Terminals & Editors**
*   [Ghostty](https://ghostty.org/) - GPU-accelerated terminal
*   [Warp](https://warp.dev/) - Modern terminal with AI
*   [Cursor](https://cursor.sh/) - AI-native code editor
*   VS Code with essential extensions

### **AI Development Tools**
*   [Claude Code](https://claude.ai/code) (Anthropic)
*   [Open Code](https://opencode.ai)
*   [Antigravity](https://antigravity.google) (Google's AI IDE)

### **Productivity & Browsers**
*   [Raycast](https://www.raycast.com/) - Spotlight replacement
*   [Arc](https://arc.net/) - Modern browser with workspaces

## Quick Start ⚡️

Clone the repository and run the automated setup:

```bash
git clone git@github.com:paul-phan/dev-setup.git
cd dev-setup
chmod +x setup.sh
./setup.sh
```

**What it does:**
- ✅ Installs Xcode CLI Tools & Homebrew
- ✅ Installs all modern tools (UV, Mise, Atuin, Zellij, Carapace, etc)
- ✅ Sets up shell (Zsh + Oh My Zsh + Starship + powerful autocompletion)
- ✅ Generates SSH & GPG keys automatically
- ✅ Configures GitHub CLI authentication
- ✅ Installs VS Code extensions (parallel)
- ✅ Configures macOS system defaults
- ✅ Shows real-time progress with time estimates

**Time:** ~10-15 minutes

### **Post-Setup Steps**

After running the setup script:

1. **Restart your terminal** to load new shell configuration
2. **Install Cursor IDE** (optional): https://cursor.sh/download
3. **Install Antigravity** (optional): https://antigravity.google/download
4. **Configure Raycast**: Open from Applications and set as Spotlight replacement

## Autocompletion Features 🎯

Your terminal now has **cutting-edge autocompletion** powered by modern tools:

### **What You Get:**

1. **Carapace** - Smart completions for 1000+ commands
   - Knows valid flags, arguments, and values for git, docker, npm, kubectl, etc.
   - Context-aware (suggests only valid options)
   - Faster than traditional completion scripts

2. **zsh-autosuggestions** - Fish-like inline suggestions
   - Gray text appears as you type (from your history)
   - Press `→` or `Ctrl+Space` to accept

3. **zsh-syntax-highlighting** - Real-time validation
   - Green = valid command
   - Red = invalid/not found
   - Helps catch typos before hitting Enter

4. **Atuin** - Magical history search
   - Press `↑` for fuzzy history search
   - SQLite-backed, searchable, synced across machines

5. **fzf** - Fuzzy finder integration
   - `Ctrl+R` - Search command history
   - `Ctrl+T` - Find files (with preview!)
   - `Alt+C` - Change directory (fuzzy)

### **How It Works:**

```bash
# Start typing, see suggestions appear in gray
git com█          # Shows: git commit (from history)
                  # Press → to accept

# Tab completion with Carapace
git <Tab>         # Shows all git subcommands
git commit -<Tab> # Shows all commit flags with descriptions

# Fuzzy history search (Atuin)
↑                 # Opens interactive search
# Type: "docker run" → finds all docker run commands

# Fuzzy file finder (fzf)
Ctrl+T            # Opens file browser with preview
                  # Type to filter, Enter to select

# Fuzzy directory changer
Alt+C             # Opens directory browser
                  # Jump to any directory quickly
```

### **Pro Tips:**

```bash
# Accept partial suggestion (zsh-autosuggestions)
Alt+→             # Accept one word from suggestion

# Navigate completion menu
Tab               # Open menu
Tab Tab           # Cycle through options
Shift+Tab         # Reverse cycle
Ctrl+N/P          # Next/Previous in menu

# Search while in completion menu
/pattern          # Filter completions (with Carapace)
```

---

## Modern Tools Usage 📚

### **Mise - Unified Version Manager**
```bash
# Install Node.js
mise use --global node@20

# Install Python
mise use --global python@3.12

# Install multiple versions
mise use node@18 node@20 python@3.11 python@3.12

# Auto-switch based on .tool-versions
cd my-project  # Automatically uses versions from .tool-versions
```

### **UV - Fast Python Package Manager**
```bash
# Create virtual environment (10-100x faster than venv)
uv venv

# Install packages (blazing fast)
uv pip install requests pandas numpy

# Install from requirements.txt
uv pip install -r requirements.txt
```

### **Atuin - Magical Shell History**
```bash
# Search history interactively
atuin search

# Search for specific command
atuin search "git commit"

# Sync history across machines (optional)
atuin login
atuin sync
```

### **Zellij - Modern Terminal Multiplexer**
```bash
# Start session
zellij

# Create new pane: Ctrl+p then n
# Switch panes: Ctrl+p then arrow keys
# Create new tab: Ctrl+t then n
```

## Customization 🛠️

*   **Dependencies**: Edit `Brewfile` to add/remove apps or tools
*   **Shell**: Edit `.zshrc` (user config) or `.aliases` (shortcuts)
*   **Git**: Edit `.gitconfig`
*   **Setup Script**: Modify `setup-2026.sh` for custom automation

## Troubleshooting 🔧

### **Setup fails during Homebrew installation**
```bash
# Clean up and retry
rm -rf /opt/homebrew
./setup-2026.sh
```

### **SSH key not working with GitHub**
```bash
# Verify SSH key is added to ssh-agent
ssh-add -l

# Test GitHub connection
ssh -T git@github.com
```

### **VS Code extensions not installing**
```bash
# Ensure VS Code CLI is in PATH
which code

# If not found, open VS Code and run:
# Cmd+Shift+P → "Shell Command: Install 'code' command in PATH"
```

## What's New in 2026 Edition 🆕

- ⚡ **3-5x faster** setup through parallel installation
- 🎯 **Progress tracking** with real-time status updates
- 🔄 **Auto-retry logic** for network-related failures
- 🔐 **Automated SSH/GPG** key generation & GitHub setup
- 🎯 **Cutting-edge autocompletion**: Carapace (1000+ commands), zsh-autosuggestions, fzf, Atuin
- 📦 **Modern tools**: UV, Mise, Atuin, Zellij, Carapace
- 🦀 **Rust CLI tools**: fd, dust, procs, btop, git-delta
- 🤖 **Cursor IDE** support (AI-native editor)
- 🌐 **Arc browser** (modern browser with workspaces)
- ✅ **Idempotent design** - run multiple times safely
- 📝 **Better logging** - detailed logs in `~/.setup-logs/`

## Credits

2026 comprehensive rewrite with modern tools, parallel installation, and complete automation.

Based on the original [dev-setup](https://github.com/donnemartin/dev-setup) by Donne Martin.
