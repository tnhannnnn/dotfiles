eval "$(/opt/homebrew/bin/brew shellenv)"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="$PATH:/Users/tnhannn/.local/bin"
export EDITOR=nvim
export VISUAL=nvim
source <(fzf --zsh)
eval "$(zoxide init zsh)"
source $HOMEBREW_PREFIX/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# eval "$(starship init zsh)"
setopt prompt_subst
PS1='%~ %# '
alias ls="eza --icons"
alias la="eza -a --icons"
alias lt="eza --tree --icons"
alias lta="eza -a --tree --icons"
alias cat="bat"
alias lg="lazygit"
alias tn="tmux new-session"
alias ta="tmux attach"
alias td="tmux detach"
alias tl="tmux list-sessions"
alias nn='NVIM_APPNAME=nvim-note nvim'
alias nv='NVIM_APPNAME=nvim nvim'
alias clock='tty-clock  -c -b -C 5 -D'
export PATH=$PATH:/Users/tnhannn/.spicetify
export DYLD_FALLBACK_LIBRARY_PATH="$(brew --prefix)/lib:$DYLD_FALLBACK_LIBRARY_PATH"
