{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    btop
    git vim wget
    fastfetch ncdu
    brightnessctl
    comma
    zsh-history-substring-search
    nixos-rebuild-ng
  ];

  environment.variables.ZSH_HSS =
    "${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh";
}
