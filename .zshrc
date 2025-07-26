# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="agnoster"

# Enable plugins
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Show modern system info (instead of deprecated neofetch)

# Vader cowsay greeting with random fortune
fortune | cowsay -f vader | lolcat

# Enable colors and correct keymap
autoload -U colors && colors
bindkey -v

# Some nice aliases
alias ll='ls -lah --color=auto'
alias update='sudo pacman -Syu'
alias grep='grep --color=auto'

# Enable auto suggestions and syntax highlighting if installed
# (install with: sudo pacman -S zsh-autosuggestions zsh-syntax-highlighting)
# Make sure they load after oh-my-zsh
if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Fix for some terminals
export TERM=xterm-256color

# Uncomment this if you use less as pager with colors
# export LESS='-R'


export PATH="$HOME/Android/Sdk/platform-tools:$PATH"
