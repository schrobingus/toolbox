{ pkgs, ... }:

{
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
  services.spice-webdavd.enable = true;

  # Video performance on UTM is very hit or miss.
  # The following enables software rendering by default,
  # whilst also adding the VirGL renderer for testing.
  environment.sessionVariables.ENABLE_SOFTWARE_RENDERING = "1";
  # environment.sessionVariables.LIBGL_ALWAYS_SOFTWARE = "1";
  environment.systemPackages = with pkgs; [ virglrenderer ];
}
