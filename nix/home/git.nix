{ ... }:

{
  # TODO: figure out how to integrate this with users?
  programs.git = {
    enable = true;
    settings = {
      diff.tool = "nvimdiff";
      merge.tool = "nvimdiff1";
      user = {
        name = "schrobingus";
        email = "brent.monning.jr@gmail.com";
      };
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };
}
