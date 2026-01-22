{ ... }:

{
  virtualisation.docker.enable = true;
  virtualisation.podman.enable = true;

  users.users.brent.extraGroups = [ "docker" ];
}
