#!/usr/bin/env bash

# setup-2026.sh
# Modern macOS Development Setup Script (2026 Edition)
# Comprehensive rewrite with parallel installation, modern tools, complete automation

set -euo pipefail

# ============================================================================
# Configuration
# ============================================================================

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly LOG_DIR="$HOME/.setup-logs"
readonly LOG_FILE="$LOG_DIR/setup-$(date +%Y%m%d-%H%M%S).log"

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[0;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Progress tracking
TOTAL_STEPS=0
CURRENT_STEP=0

# ============================================================================
# Utility Functions
# ============================================================================

# Setup logging
setup_logging() {
    mkdir -p "$LOG_DIR"
    exec > >(tee -a "$LOG_FILE")
    exec 2>&1
}

# Print with color and status icon
print_status() {
    local status=$1
    shift
    local message="$*"

    case $status in
        success)
            echo -e "${GREEN}[✓]${NC} $message"
            ;;
        error)
            echo -e "${RED}[✗]${NC} $message"
            ;;
        info)
            echo -e "${BLUE}[→]${NC} $message"
            ;;
        warning)
            echo -e "${YELLOW}[!]${NC} $message"
            ;;
    esac
}

# Print progress
print_progress() {
    ((CURRENT_STEP++))
    local message="$1"
    echo -e "${BLUE}[${CURRENT_STEP}/${TOTAL_STEPS}]${NC} $message"
}

# Retry wrapper with exponential backoff
retry_command() {
    local max_attempts=3
    local timeout=1
    local attempt=1
    local exitCode=0

    while [ $attempt -le $max_attempts ]; do
        if "$@"; then
            return 0
        else
            exitCode=$?
        fi

        if [ $attempt -lt $max_attempts ]; then
            print_warning "Attempt $attempt failed. Retrying in ${timeout}s..."
            sleep $timeout
            timeout=$((timeout * 2))
        fi
        ((attempt++))
    done

    print_error "Command failed after $max_attempts attempts"
    return $exitCode
}

# Check if command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Run commands in parallel and wait
run_parallel() {
    local pids=()

    for cmd in "$@"; do
        eval "$cmd" &
        pids+=($!)
    done

    # Wait for all background jobs
    for pid in "${pids[@]}"; do
        wait "$pid"
    done
}

# ============================================================================
# Phase 1: Bootstrap (Sequential - Foundation)
# ============================================================================

bootstrap_xcode() {
    print_progress "Installing Xcode Command Line Tools..."

    if xcode-select -p &> /dev/null; then
        print_status success "Xcode Command Line Tools already installed"
        return 0
    fi

    print_status info "This may take 5-10 minutes..."
    xcode-select --install 2>/dev/null || true

    # Wait for installation to complete
    until xcode-select -p &> /dev/null; do
        sleep 5
    done

    print_status success "Xcode Command Line Tools installed"
}

bootstrap_homebrew() {
    print_progress "Installing Homebrew..."

    if command_exists brew; then
        print_status success "Homebrew already installed"
        return 0
    fi

    print_status info "This typically takes 2-3 minutes..."
    retry_command /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for the current session
    if [[ $(uname -m) == 'arm64' ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi

    print_status success "Homebrew installed"
}

# ============================================================================
# Phase 2: Core Tools (Parallel where possible)
# ============================================================================

install_homebrew_packages() {
    print_progress "Installing Homebrew packages from Brewfile..."

    # Cleanup potential issues
    brew untap homebrew/cask-fonts 2>/dev/null || true
    rm -f "$SCRIPT_DIR/Brewfile.lock.json"

    print_status info "Updating Homebrew..."
    brew update

    print_status info "Installing packages (this may take 5-15 minutes)..."
    brew bundle --file="$SCRIPT_DIR/Brewfile"

    print_status success "Homebrew packages installed"
}

install_modern_tools() {
    print_progress "Installing modern CLI tools..."

    local tools_installed=0
    local tools_total=4

    # UV - Fast Python package manager
    if ! command_exists uv; then
        print_status info "Installing UV (Fast Python package manager)..."
        retry_command curl -LsSf https://astral.sh/uv/install.sh | sh
        ((tools_installed++))
    else
        print_status success "UV already installed"
        ((tools_installed++))
    fi

    # Mise - Unified version manager
    if ! command_exists mise; then
        print_status info "Installing Mise (unified version manager)..."
        retry_command curl https://mise.run | sh
        ((tools_installed++))
    else
        print_status success "Mise already installed"
        ((tools_installed++))
    fi

    # Atuin - Magical shell history
    if ! command_exists atuin; then
        print_status info "Installing Atuin (magical shell history)..."
        retry_command curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
        ((tools_installed++))
    else
        print_status success "Atuin already installed"
        ((tools_installed++))
    fi

    # Zellij is in Brewfile, just verify
    if command_exists zellij; then
        print_status success "Zellij installed via Homebrew"
        ((tools_installed++))
    fi

    print_status success "Modern CLI tools installed ($tools_installed/$tools_total)"
}

install_ai_tools() {
    print_progress "Installing AI development tools..."

    local pids=()

    # Claude Code (parallel)
    if ! command_exists claude; then
        print_status info "Installing Claude Code..."
        (npm install -g @anthropic-ai/claude-code 2>&1 | tee -a "$LOG_FILE") &
        pids+=($!)
    else
        print_status success "Claude Code already installed"
    fi

    # Open Code (parallel)
    if ! command_exists opencode; then
        print_status info "Installing Open Code..."
        (retry_command curl -fsSL https://opencode.ai/install.sh | sh 2>&1 | tee -a "$LOG_FILE") &
        pids+=($!)
    else
        print_status success "Open Code already installed"
    fi

    # Wait for parallel installations
    if [ ${#pids[@]} -gt 0 ]; then
        for pid in "${pids[@]}"; do
            wait "$pid"
        done
    fi

    print_status success "AI tools installed"
}

# ============================================================================
# Phase 3: Shell Setup
# ============================================================================

setup_shell() {
    print_progress "Setting up Zsh and Oh My Zsh..."

    # Install Oh My Zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        print_status info "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        print_status success "Oh My Zsh already installed"
    fi

    # Backup and symlink dotfiles
    for file in .zshrc .aliases .gitconfig; do
        if [ -f "$HOME/$file" ] && [ ! -L "$HOME/$file" ]; then
            print_status warning "Backing up existing $file to $file.backup"
            mv "$HOME/$file" "$HOME/$file.backup"
        fi
        ln -sf "$SCRIPT_DIR/$file" "$HOME/$file"
        print_status success "Symlinked $file"
    done

    print_status success "Shell setup complete"
}

# ============================================================================
# Phase 4: SSH/GPG Keys & GitHub Setup
# ============================================================================

setup_ssh_keys() {
    print_progress "Setting up SSH keys..."

    local ssh_dir="$HOME/.ssh"
    local ssh_key="$ssh_dir/id_ed25519"

    mkdir -p "$ssh_dir"
    chmod 700 "$ssh_dir"

    if [ -f "$ssh_key" ]; then
        print_status success "SSH key already exists"
        return 0
    fi

    # Get user email for key comment
    local email
    email=$(git config --global user.email 2>/dev/null || echo "")

    if [ -z "$email" ]; then
        print_status warning "Git email not configured. Please enter your email:"
        read -r email
        git config --global user.email "$email"
    fi

    print_status info "Generating ED25519 SSH key..."
    ssh-keygen -t ed25519 -C "$email" -f "$ssh_key" -N ""

    # Set proper permissions
    chmod 600 "$ssh_key"
    chmod 644 "$ssh_key.pub"

    # Add to ssh-agent
    eval "$(ssh-agent -s)"

    # Add to macOS keychain
    if [[ "$OSTYPE" == "darwin"* ]]; then
        ssh-add --apple-use-keychain "$ssh_key" 2>/dev/null || ssh-add "$ssh_key"
    else
        ssh-add "$ssh_key"
    fi

    print_status success "SSH key generated and added to ssh-agent"

    # Display public key for GitHub
    echo ""
    print_status info "Your SSH public key (copy this to GitHub):"
    echo ""
    cat "$ssh_key.pub"
    echo ""
    print_status warning "Press Enter after adding this key to GitHub..."
    read -r
}

setup_gpg_keys() {
    print_progress "Setting up GPG keys..."

    # Check if GPG key already exists
    if gpg --list-secret-keys --keyid-format=long 2>/dev/null | grep -q "sec"; then
        print_status success "GPG key already exists"
        return 0
    fi

    local email
    email=$(git config --global user.email 2>/dev/null || echo "")
    local name
    name=$(git config --global user.name 2>/dev/null || echo "")

    if [ -z "$name" ]; then
        print_status warning "Git name not configured. Please enter your name:"
        read -r name
        git config --global user.name "$name"
    fi

    if [ -z "$email" ]; then
        print_status warning "Git email not configured. Please enter your email:"
        read -r email
        git config --global user.email "$email"
    fi

    print_status info "Generating GPG key for $name <$email>..."

    # Generate GPG key in batch mode
    gpg --batch --generate-key <<EOF
Key-Type: RSA
Key-Length: 4096
Subkey-Type: RSA
Subkey-Length: 4096
Name-Real: $name
Name-Email: $email
Expire-Date: 0
%no-protection
%commit
EOF

    # Get the key ID
    local key_id
    key_id=$(gpg --list-secret-keys --keyid-format=long | grep "^sec" | head -1 | sed 's|.*/\([^ ]*\) .*|\1|')

    # Configure git to use GPG
    git config --global user.signingkey "$key_id"
    git config --global commit.gpgsign true

    print_status success "GPG key generated and configured for Git"

    # Display public key for GitHub
    echo ""
    print_status info "Your GPG public key (copy this to GitHub):"
    echo ""
    gpg --armor --export "$key_id"
    echo ""
    print_status warning "Press Enter after adding this key to GitHub..."
    read -r
}

setup_github_cli() {
    print_progress "Setting up GitHub CLI..."

    if ! command_exists gh; then
        print_status error "GitHub CLI not installed (should be in Brewfile)"
        return 1
    fi

    # Check if already authenticated
    if gh auth status &>/dev/null; then
        print_status success "GitHub CLI already authenticated"
        return 0
    fi

    print_status info "Authenticating with GitHub..."
    gh auth login

    print_status success "GitHub CLI authenticated"
}

# ============================================================================
# Phase 5: VS Code Extensions (Parallel)
# ============================================================================

install_vscode_extensions() {
    print_progress "Installing VS Code extensions..."

    if ! command_exists code; then
        print_status warning "VS Code CLI not available, skipping extensions"
        return 0
    fi

    local extensions=(
        "biomejs.biome"
        "eamodio.gitlens"
        "pkief.material-icon-theme"
        "zhuangtongfa.material-theme"
        "formulahendry.auto-close-tag"
        "formulahendry.auto-rename-tag"
        "dbaeumer.vscode-eslint"
        "esbenp.prettier-vscode"
    )

    print_status info "Installing ${#extensions[@]} extensions in parallel..."

    local pids=()
    for ext in "${extensions[@]}"; do
        (code --install-extension "$ext" --force 2>&1 | tee -a "$LOG_FILE") &
        pids+=($!)
    done

    # Wait for all extensions
    if [ ${#pids[@]} -gt 0 ]; then
        for pid in "${pids[@]}"; do
            wait "$pid"
        done
    fi

    print_status success "VS Code extensions installed"
}

# ============================================================================
# Phase 6: macOS System Configuration
# ============================================================================

configure_macos() {
    print_progress "Configuring macOS system defaults..."

    print_status info "Setting Finder preferences..."
    defaults write com.apple.finder AppleShowAllFiles -bool true
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true
    defaults write com.apple.finder ShowPathbar -bool true
    defaults write com.apple.finder ShowStatusBar -bool true

    print_status info "Setting Dock preferences..."
    defaults write com.apple.dock autohide -bool true
    defaults write com.apple.dock tilesize -int 48

    print_status info "Setting keyboard preferences..."
    defaults write NSGlobalDomain KeyRepeat -int 2
    defaults write NSGlobalDomain InitialKeyRepeat -int 15

    print_status info "Setting trackpad preferences..."
    defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

    # Restart affected apps
    killall Finder 2>/dev/null || true
    killall Dock 2>/dev/null || true

    print_status success "macOS configuration complete"
}

# ============================================================================
# Main Setup Flow
# ============================================================================

print_banner() {
    echo ""
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║                                                            ║"
    echo "║       macOS Developer Setup 2026 Edition 🚀                ║"
    echo "║                                                            ║"
    echo "║  Complete automated setup with modern tools & best practices ║"
    echo "║                                                            ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo ""
}

calculate_total_steps() {
    TOTAL_STEPS=11  # Update this if you add/remove phases
}

print_summary() {
    echo ""
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║                    Setup Complete! 🎉                      ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo ""
    print_status success "All tools and configurations installed"
    echo ""
    echo "Next steps:"
    echo "  1. Restart your terminal to load new shell configuration"
    echo "  2. Install Cursor IDE: https://cursor.sh/download"
    echo "  3. Install Antigravity: https://antigravity.google/download"
    echo "  4. Configure Raycast (open from Applications)"
    echo ""
    echo "Installed modern tools:"
    echo "  • UV - Fast Python package manager (try: uv --help)"
    echo "  • Mise - Unified version manager (try: mise --version)"
    echo "  • Atuin - Magical shell history (try: atuin search)"
    echo "  • Zellij - Modern terminal multiplexer (try: zellij)"
    echo ""
    echo "Log file: $LOG_FILE"
    echo ""
}

main() {
    setup_logging
    print_banner
    calculate_total_steps

    # Phase 1: Bootstrap (Sequential)
    bootstrap_xcode
    bootstrap_homebrew

    # Phase 2: Core Tools (Some parallel)
    install_homebrew_packages
    install_modern_tools
    install_ai_tools

    # Phase 3: Shell Setup
    setup_shell

    # Phase 4: Keys & GitHub (Interactive)
    setup_ssh_keys
    setup_gpg_keys
    setup_github_cli

    # Phase 5: VS Code (Parallel)
    install_vscode_extensions

    # Phase 6: System Config
    configure_macos

    # Done!
    print_summary
}

# Run main
main "$@"
