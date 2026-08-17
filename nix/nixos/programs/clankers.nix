{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    opencode pi-coding-agent

    nodejs
    (writeShellApplication {
      name = "opencode-compat";
      text = ''
        exec ${nodejs}/bin/npx opencode-ai@latest "$@"
      '';
    })
  ];
}
