# Oh My Zsh manages completion, history, aliases and shell helpers.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="agnoster-catppuccin"
zstyle ':omz:update' mode reminder
plugins=(git zsh-autosuggestions)
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
source "$ZSH/oh-my-zsh.sh"
setopt HIST_IGNORE_ALL_DUPS HIST_REDUCE_BLANKS

# Keep the developer tools already configured in Bash available in Zsh.
typeset -U path PATH
path=("$HOME/.local/bin" "$HOME/bin" "$HOME/.opencode/bin" $path "$HOME/.lmstudio/bin")
export PNPM_HOME="$HOME/.local/share/pnpm"
path=("$PNPM_HOME/bin" $path)
[[ -r "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"

# Colours for common commands and completion results.
[[ -x /usr/bin/dircolors ]] && eval "$(dircolors -b)"
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#7f849c'
bindkey -e
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

# The Agnoster Catppuccin theme supplies the single-line prompt.

# Private machine-specific settings stay outside this repository.
[[ -r "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

# Highlighting must load last so it sees all other ZLE widgets.
source "$ZSH/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
ZSH_HIGHLIGHT_STYLES[default]='fg=#cdd6f4'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#f38ba8,bold'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#cba6f7'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[function]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[command]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[path]='fg=#89b4fa,underline'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#f9e2af'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#f9e2af'
ZSH_HIGHLIGHT_STYLES[comment]='fg=#7f849c'
