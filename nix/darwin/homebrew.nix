{ ... }:

{
  homebrew = {
    enable = true;

    taps = [
      # "d12frosted/emacs-plus"
      # "railwaycat/emacsmacport"
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
      "librewolf" # NOTE: librewolf is deprecated as a cask, since they don't sign. homebrew is big mad about this, either create a tap or migrate to darwin
      # "emacs" # TODO: update to match the current emacs installation
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
