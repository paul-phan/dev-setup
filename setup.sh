#!/usr/bin/env bash

# setup.sh
# Modern macOS Development Setup Script (2025)

set -e

echo "🚀 Starting macOS setup..."

# 1. Install Homebrew if not installed
if ! command -v brew &> /dev/null; then
    echo "🍺 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for the current session
    if [[ $(uname -m) == 'arm64' ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo "✅ Homebrew is already installed"
fi

# 2. Update Homebrew and Install Dependencies from Brewfile
echo "📦 Installing dependencies from Brewfile..."
# Cleanup potential deprecated taps that cause errors
brew untap homebrew/cask-fonts 2>/dev/null || true
rm -f Brewfile.lock.json

brew update
brew bundle --file=./Brewfile

# 3. Install AI Tools
echo "🤖 Installing AI Tools..."

# Claude Code
if ! command -v claude &> /dev/null; then
    echo "  - Installing Claude Code..."
    npm install -g @anthropic-ai/claude-code
else
   echo "  - Claude Code already installed"
fi

# Open Code
if ! command -v opencode &> /dev/null; then
    echo "  - Installing Open Code..."
    curl -fsSL https://opencode.ai/install.sh | sh
else
    echo "  - Open Code already installed"
fi

# 4. Setup Shell (Oh My Zsh + Zsh + Starship)
echo "🐚 Setting up Zsh..."

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "  - Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "  - Oh My Zsh already installed"
fi

# Symlink .zshrc
if [ -f "$HOME/.zshrc" ]; then
    echo "backing up existing .zshrc to .zshrc.backup"
    mv "$HOME/.zshrc" "$HOME/.zshrc.backup"
fi
ln -sf "$(pwd)/.zshrc" "$HOME/.zshrc"

# Symlink .aliases
if [ -f "$HOME/.aliases" ]; then
    echo "backing up existing .aliases to .aliases.backup"
    mv "$HOME/.aliases" "$HOME/.aliases.backup"
fi
ln -sf "$(pwd)/.aliases" "$HOME/.aliases"

# Symlink .gitconfig
echo "🔧 Setting up Git config..."
if [ -f "$HOME/.gitconfig" ]; then
    echo "backing up existing .gitconfig to .gitconfig.backup"
    mv "$HOME/.gitconfig" "$HOME/.gitconfig.backup"
fi
ln -sf "$(pwd)/.gitconfig" "$HOME/.gitconfig"

# 5. VS Code Extensions
echo "💻 Installing VS Code extensions..."
# Essential
code --install-extension biomejs.biome
code --install-extension eamodio.gitlens
# UI/UX
code --install-extension pkief.material-icon-theme
code --install-extension zhuangtongfa.material-theme
code --install-extension formulahendry.auto-close-tag
code --install-extension formulahendry.auto-rename-tag

# 6. macOS System Defaults (Optional but recommended)
echo "🍎 Setting up macOS defaults..."
# Finder: show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true
# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true
# Dock: autohide
defaults write com.apple.dock autohide -bool true
# Key repeat speed
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Restart Finder and Dock
killall Finder
killall Dock

echo ""
echo "🎉 Setup complete! Please restart your terminal."
echo ""
echo "ℹ️  Manual Steps Required:"
echo "   1. Install Antigravity (Google's AI IDE):"
echo "      - Download from: https://antigravity.google/download"
echo "      - Run installer."
echo "   2. Configure Raycast:"
echo "      - Open Raycast and set it up as your Spotlight replacement."
echo ""
