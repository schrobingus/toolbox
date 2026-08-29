{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    zsh-history-substring-search

    comma
    git btop fd ncdu
    fastfetch ripgrep vim wget
    pfetch zstd p7zip
    nix-output-monitor nixos-rebuild-ng

    texliveFull typst
    pandoc marp-cli
    yt-dlp
    exercism
  ];

  environment.variables.ZSH_HSS =
    "${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh";
}
