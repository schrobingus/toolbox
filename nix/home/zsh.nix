{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;

    # This is used to initialize the `zshrc`, which often doesn't load due to conflicts.
    initContent = /* sh */ ''
    if [ -e "$HOME/.zprofile" ]; then
      source $HOME/.zprofile
    fi

    if [ -e "$HOME/.profile" ]; then
      source $HOME/.profile
    fi

    if [ -e "$HOME/.config/zsh/rc.zsh" ]; then
      source $HOME/.config/zsh/rc.zsh
    else
      source $HOME/.zshrc
    fi

    if [ -e "$HOME/.config/zsh/extra.zsh" ]; then
      source $HOME/.config/zsh/extra.zsh
    fi
    '';

    # Disable the Nix `command_not_found_handle`, which takes like 2 whole seconds to run.
    loginExtra = /* sh */ ''
    unset -f command_not_found_handler 2>/dev/null
    unset -f command_not_found_handle 2>/dev/null
    '';

    plugins = [
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "0.8.0";
          hash = "sha256-iJdWopZwHpSyYl5/FQXEW7gl/SrKaYDEtTH9cGP7iPo=";
        };
      }
      {
        name = "zsh-history-substring-search";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-history-substring-search";
          rev = "v1.1.0";
          hash = "sha256-GSEvgvgWi1rrsgikTzDXokHTROoyPRlU0FVpAoEmXG4=";
        };
      }
      # {
      #   name = "nix-zsh-completions";
      #   src = pkgs.fetchFromGitHub {
      #     owner = "nix-community";
      #     repo = "nix-zsh-completions";
      #     rev = "0.5.1";
      #     hash = "sha256-bgbMc4HqigqgdkvUe/CWbUclwxpl17ESLzCIP8Sz+F8=";
      #   };
      # }
      {
        name = "zsh-nix-shell";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.8.0";
          hash = "sha256-Z6EYQdasvpl1P78poj9efnnLj7QQg13Me8x1Ryyw+dM=";
        };
      }
      # {
      #   name = "zsh-syntax-highlighting";
      #   src = pkgs.zsh-syntax-highlighting;
      # }
      # {
      #   name = "zsh-history-substring-search";
      #   src = pkgs.zsh-history-substring-search;
      # }
      # {
      #   name = "zsh-nix-shell";
      #   src = pkgs.zsh-nix-shell;
      # }
    ];
  };
}
