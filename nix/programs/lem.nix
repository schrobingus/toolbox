{ inputs, pkgs, ... }:

{
  nixpkgs.overlays = [ inputs.lem.overlays.default ];

  environment.systemPackages = with pkgs; [
    lem-webview lem-ncurses
    (writeShellApplication {
      name = "lem-webview";
      text = "${lem-webview}/bin/lem \"$@\"";
    })
    (writeShellApplication {
      name = "lem-ncurses";
      text = "${lem-ncurses}/bin/lem \"$@\"";
    })
  ];
}