
# zmodload zsh/zprof

# Below disables case sensitivity.
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
autoload -Uz compinit && compinit

setopt HIST_IGNORE_ALL_DUPS

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

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

if pathHas nixos-rebuild-ng; then
  alias nrs="sudo nixos-rebuild-ng switch"
  alias nrf="sudo nixos-rebuild-ng switch --flake $DOTDIR"
elif pathHas nixos-rebuild; then
  alias nrs="sudo nixos-rebuild switch"
  alias nrf="sudo nixos-rebuild switch --flake $DOTDIR"
fi

if pathHas darwin-rebuild; then
  alias drs="sudo darwin-rebuild switch"
  alias drf="sudo darwin-rebuild switch --flake $DOTDIR"
elif [[ "$(uname)" -eq "Darwin" ]] && pathHas nix; then
  alias drs="echo 'darwin-rebuild binary not found, pulling from github...' && sudo nix run nix-darwin/master#darwin-rebuild -- switch"
  alias drf="echo 'darwin-rebuild binary not found, pulling from github...' && sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake $DOTDIR"
fi

if pathHas home-manager; then
  alias nhs="home-manager switch"
  alias nhf="home-manager switch --flake $DOTDIR"
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

