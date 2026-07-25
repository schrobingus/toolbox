
# zmodload zsh/zprof

# Below disables case sensitivity.
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
autoload -Uz compinit && compinit

setopt HIST_IGNORE_ALL_DUPS

# Set up history substring search. Will ignore if not installed via Nix.
if [[ -n "$ZSH_HSS" && -f "$ZSH_HSS" ]]; then
    source "$ZSH_HSS"
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
    bindkey -M emacs '^P' history-substring-search-up
    bindkey -M emacs '^N' history-substring-search-down
    bindkey -M vicmd 'k' history-substring-search-up
    bindkey -M vicmd 'j' history-substring-search-down
    HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
fi

setopt interactive_comments

autoload -U colors && colors

setopt prompt_subst
PROMPT='%B%n%F{9}@%m %F{10}%~ %F{14}$(git branch --show-current 2>/dev/null)
%F{12}%(?..%F{1}%? )>%f%b '

# Clean alias for checking if a command is in the PATH.
pathHas() { command -v "$1" >/dev/null 2>&1 }

if pathHas nix; then
    alias nd="nix develop" # NOTE: consider using `nom` if present?
    alias nsh="nix-shell"
    alias ncs="nix-store --gc && sudo nix-store --gc"
    alias ncg="nix-collect-garbage -d && sudo nix-collect-garbage -d"
fi

if pathHas nix-channel; then
    alias ncu="nix-channel --update && sudo nix-channel --update"
    alias ncui="nix-channel --update -vvvvv && sudo nix-channel --update -vvvvv"
fi

if pathHas nixos-rebuild; then
    alias nrs="sudo nixos-rebuild switch"
    alias nrf="sudo nixos-rebuild switch --flake $TOOLBOX_DIRECTORY"
fi

if pathHas darwin-rebuild; then
    alias drs="sudo darwin-rebuild switch"
    alias drf="sudo darwin-rebuild switch --flake $TOOLBOX_DIRECTORY"
elif [[ "$(uname)" -eq "Darwin" ]] && pathHas nix; then
    alias drs="echo 'darwin-rebuild binary not found, pulling from github...' && sudo nix run nix-darwin/master#darwin-rebuild -- switch"
    alias drf="echo 'darwin-rebuild binary not found, pulling from github...' && sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake $TOOLBOX_DIRECTORY"
fi

if pathHas home-manager; then
    alias nhs="home-manager switch"
    alias nhf="home-manager switch --flake $TOOLBOX_DIRECTORY"
fi

if pathHas zoxide; then
    eval "$(zoxide init zsh)"
    alias cd=z
fi

if [[ -f "/usr/bin/arch" ]]; then
    alias x86_sh="/usr/bin/arch -x86_64 /bin/zsh"
fi

if pathHas doas && ! pathHas sudo; then
    alias sudo="doas"
fi

alias ls="ls -lH --color=auto"
alias x="startx"
alias allah="sudo"

# zprof
