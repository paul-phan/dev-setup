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
plugins=(git)
[ -f "$ZSH/oh-my-zsh.sh" ] && source "$ZSH/oh-my-zsh.sh"

# --- Tools Initialization ---

# Starship Prompt
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

# fnm (Fast Node Manager)
if command -v fnm &> /dev/null; then
    eval "$(fnm env --use-on-cd)"
fi

# zoxide (better cd)
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
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
