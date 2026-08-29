{ pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # networking.wireless.enable = false;
  networking.networkmanager.enable = true;

  time.timeZone = "America/Los_Angeles";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.xserver = {
    xkb = {
      layout = "us";
      variant = "";
    };
    displayManager.lightdm.enable = false;
  };

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  users.users.brent = {
    isNormalUser = true;
    description = "Brent";
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
  };

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };
  };

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 80 443 9090 61208 ];

  system.stateVersion = "25.11";
}
