# .zshrc

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# --- Essentials ---
export TERM="xterm-256color"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Path configuration
export PATH="$HOME/bin:/usr/local/bin:$PATH"

# Add Homebrew to PATH
if [[ -f "/opt/homebrew/bin/brew" ]]; then
  # Apple Silicon
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/usr/local/bin/brew" ]]; then
  # Intel
  eval "$(/usr/local/bin/brew shellenv)"
fi

# --- Oh My Zsh ---
export ZSH="$HOME/.oh-my-zsh"
# Disable OMZ theme so Starship can take over (or use a minimal one)
ZSH_THEME="robbyrussell"

# Enable powerful Oh My Zsh plugins for autocompletion
plugins=(
    git                    # Git aliases and completions
    docker                 # Docker completions
    docker-compose         # Docker Compose completions
    npm                    # npm completions
    node                   # Node.js completions
    python                 # Python completions
    pip                    # pip completions
    brew                   # Homebrew completions
    macos                  # macOS specific aliases
    vscode                 # VS Code aliases
    web-search             # Search from terminal
    jsontools              # JSON tools
    colored-man-pages      # Colorize man pages
    command-not-found      # Suggest packages for missing commands
    sudo                   # Press ESC twice to add sudo
)

[ -f "$ZSH/oh-my-zsh.sh" ] && source "$ZSH/oh-my-zsh.sh"

# --- Tools Initialization ---

# Starship Prompt
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

# Mise (unified version manager)
if command -v mise &> /dev/null; then
    eval "$(mise activate zsh)"
fi

# zoxide (better cd)
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
fi

# Atuin (magical shell history)
if command -v atuin &> /dev/null; then
    eval "$(atuin init zsh)"
fi

# UV (Fast Python package manager)
if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi

# --- Aliases ---
[ -f ~/.aliases ] && source ~/.aliases

# --- History ---
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt sharehistory
setopt incappendhistory

# --- Autocompletion Enhancements ---

# Carapace - Modern completion generator (1000+ commands)
# Must be loaded BEFORE compinit for best results
if command -v carapace &> /dev/null; then
    export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # Enable cross-shell support
    zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
    source <(carapace _carapace)
fi

# Load zsh-completions if installed via Homebrew
if type brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh-completions:$FPATH"
fi

# Initialize completion system
autoload -Uz compinit
compinit

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Colorful completion menu
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Fish-like autosuggestions (suggests commands as you type)
if [ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
    source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    # Configure autosuggestions color (gray)
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'
    # Accept suggestion with Ctrl+Space or Right Arrow
    bindkey '^ ' autosuggest-accept  # Ctrl+Space
fi

# Syntax highlighting (must be loaded last!)
if [ -f "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
    source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# FZF fuzzy completion (Ctrl+T for files, Ctrl+R for history, Alt+C for cd)
if [ -f ~/.fzf.zsh ]; then
    source ~/.fzf.zsh
elif command -v fzf &> /dev/null; then
    # Setup fzf key bindings and fuzzy completion
    eval "$(fzf --zsh)"
fi

# FZF configuration for better UX
export FZF_DEFAULT_OPTS="
    --height 40%
    --layout=reverse
    --border
    --preview 'bat --style=numbers --color=always --line-range :500 {}'
    --preview-window right:60%:wrap
    --bind ctrl-u:preview-page-up,ctrl-d:preview-page-down
"

# Use fd instead of find for fzf (faster, respects .gitignore)
if command -v fd &> /dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
fi

. "$HOME/.atuin/bin/env"
