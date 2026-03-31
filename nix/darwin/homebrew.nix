{ ... }:

{
  homebrew = {
    enable = true;

    taps = [
      # "d12frosted/emacs-plus"
      "railwaycat/emacsmacport"
    ];
    brews = [
      "cocoapods"
      "xcodes" "xcode-build-server"

      # "rclone"
      "ollama"
      "podman" "podman-compose"
      "qemu"
      "wireguard-tools"
    ];
    casks = [
      "librewolf"
      "emacs"
      "ghostty@tip"
      "raycast"
      "rectangle"

      "discord"
      "slack"

      "android-studio"
      "obs"
      "utm"

      # "iina"  # disabled for manually compiled `macos-tahoe` branch
      "skim"
      "openscad@snapshot"
      "steam"

      "prusaslicer"

      "coconutbattery"

      "macfuse"
    ];
  };
}
