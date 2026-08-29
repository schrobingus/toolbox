{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    opencode pi-coding-agent
  ] ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
    (pkgs.writeShellApplication {
      name = "opencode-compat";
      text = ''
        exec ${pkgs.nodejs}/bin/npx opencode-ai@latest "$@"
      '';
    })
  ];
}
