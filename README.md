# Modern macOS Dev Setup (2025 Edition) 🚀

A streamlined, automated developer setup for macOS, tailored for Frontend Engineers (React, Node.js, TypeScript).

## Features ✨

*   **Automated Setup**: One script to install everything (`./setup.sh`).
*   **Package Management**: [Homebrew](https://brew.sh/) & declarative `Brewfile`.
*   **Shell**: Zsh + [Oh My Zsh](https://ohmyz.sh/) + [Starship](https://starship.rs/) prompt due to user request.
*   **Modern CLI Tools**:
    *   `eza` (modern `ls`)
    *   `bat` (modern `cat`)
    *   `ripgrep` (faster `grep`)
    *   `zoxide` (smarter `cd`)
    *   `fnm` (Fast Node Manager)
*   **Terminal**: [Ghostty](https://ghostty.org/) (GPU-accelerated terminal).
*   **Editor**: VS Code with essential extensions and [Biome](https://biomejs.dev/) for linting/formatting.
*   **AI Tools**:
    *   [Claude Code](https://claude.ai) (Anthropic)
    *   [Open Code](https://opencode.ai)
    *   [Antigravity](https://antigravity.google) (Google's AI IDE)
*   **Productivity**: [Raycast](https://www.raycast.com/) (Spotlight replacement).

## Quick Start ⚡️

1.  Clone this repository:
    ```bash
    git clone git@github.com:paul-phan/dev-setup.git
    cd dev-setup
    ```

2.  Run the setup script:
    ```bash
    chmod +x setup.sh
    ./setup.sh
    ```

3.  **Manual Steps** (after script finishes):
    *   **Antigravity**: Download and install from [antigravity.google/download](https://antigravity.google/download).
    *   **Raycast**: Launch Raycast and follow the setup guide.

## Customization 🛠️

*   **Dependencies**: Edit `Brewfile` to add/remove apps or tools.
*   **Shell**: Edit `.zshrc` (user config) or `.aliases` (shortcuts).
*   **Git**: Edit `.gitconfig`.

## Credits

Updated and modernized for 2025 by specific user request. 
Based on the original [dev-setup](https://github.com/paul-phan/dev-setup) by [Paul Phan].
