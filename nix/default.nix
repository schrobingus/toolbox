{ toolboxDirectory, ... }:

{
  nixpkgs.config.allowUnfree = true;

  environment.variables.TOOLBOX_DIRECTORY = toolboxDirectory;
}