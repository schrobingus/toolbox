{ lib, pkgs, ... }:

let
  emacsPlusPatches = [ # For Emacs 30.2, Emacs Plus Commit b7f4710.

    # COMMUNITY PATCHES
    (pkgs.fetchpatch { # Unfuck the TTY/PTY buffer on macOS with aggressive read buffering.
      url    = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/b7f47101868eeda09ec75251eabb0cce7446abb2/community/patches/aggressive-read-buffering/emacs-30.patch";
      sha256 = "sha256-WzPfcgF0IGU8jlEjU6Bryo4u/GZNpbr5B26qEpIhi5o=";
    })

    # DEFAULT PATCHES
    (pkgs.fetchpatch { # Fix lag when scrolling on Tahoe.
      url    = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/b7f47101868eeda09ec75251eabb0cce7446abb2/patches/emacs-30/fix-macos-tahoe-scrolling.patch";
      sha256 = "sha256-Hf9oZ5ImBnxTLa6yS02UDzBEgJEGAwNq/svJ3S35uKw=";
    })
    (pkgs.fetchpatch { # Refresh x-colors during NS initialization.
      url    = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/b7f47101868eeda09ec75251eabb0cce7446abb2/patches/emacs-30/fix-ns-x-colors.patch";
      sha256 = "sha256-oe3DFgEXwp0cZJl+ufWqTonaeWSliikTRsVDNbcy4Yw=";
    })
    (pkgs.fetchpatch { # Fix window role, for window managers detecting Emacs frames.
      url    = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/b7f47101868eeda09ec75251eabb0cce7446abb2/patches/emacs-28/fix-window-role.patch";
      sha256 = "sha256-+z/KfsBm1lvZTZNiMbxzXQGRTjkCFO4QPlEK35upjsE=";
    })
    (pkgs.fetchpatch { # Provide an undecorated frame with rounded corners.
      url    = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/b7f47101868eeda09ec75251eabb0cce7446abb2/patches/emacs-30/round-undecorated-frame.patch";
      sha256 = "sha256-fesZ0H3LO6T2AiRV8ASozKxZBpvVzwLEcLDy6rctR6c=";
    })
    (pkgs.fetchpatch { # Make Emacs aware of light / dark mode changes.
      url    = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/b7f47101868eeda09ec75251eabb0cce7446abb2/patches/emacs-30/system-appearance.patch";
      sha256 = "sha256-3QLq91AQ6E921/W9nfDjdOUWR8YVsqBAT/W9c1woqAw=";
    })
  ];
  cflags = lib.concatStringsSep " " [
    "-O3"                             # Aggressive (build) compilation.
    "-fno-math-errno"                 # Don't set errno after math functions.
    "-funsafe-math-optimizations"     # Reorders and transforms float ops.
    "-fno-finite-math-only"           # Still put in safeguards for NaN.
    "-fno-trapping-math"              # Gives more freedom for float operations.
    "-freciprocal-math"               # Calculate x/y as x * 1/y.
    "-fno-rounding-math"              # Assume the rounding mode is round-to-nearest.
    "-fno-signaling-nans"             # Disable signaling NaNs.
    "-fassociative-math"              # Allow float manipulation to be reordered.
    "-fno-signed-zeros"               # Treat -0.0 and +0.0 as identical.
    "-frename-registers"              # Dependency reduction, great for ARM.
    "-funroll-loops"                  # Unroll loops whose iteration is obvious.
    "-fomit-frame-pointer"            # Don't maintain a frame pointer.

    # Target the CPU the build runs on for optimization. This kills portability, though.
    "-march=native"
    "-mtune=native"
  ];
in pkgs.emacs30.overrideAttrs (oldAttrs: { # TODO: swap nixpkgs unstable out for a stable release (likely 26.05) to reduce repetitive builds over time
  patches = (oldAttrs.patches or []) ++ emacsPlusPatches ++ [
    # Add a Canvas API to Emacs.
    # (pkgs.fetchpatch {
    #   url    = "https://raw.githubusercontent.com/minad/emacs-canvas-patch/refs/heads/main/canvas.diff";
    #   sha256 = "1jrn222w1nfjqzhiiy91q21hvh9xbsm9rhsp5r8ybq6cpfh216k4";
    # })
  ];

  configureFlags = (oldAttrs.configureFlags or []) ++ [
    "--with-native-compilation"   # Enable native compilation for Elisp.
    "--with-modules"              # Enable dynamic module loading.
    "--with-xwidgets"             # Enable XWidgets support, including a WebKit buffer.
    "--with-tree-sitter"          # Enable Treesitter.
    "--with-gnutls"               # Enable TLS.
    "--with-json"                 # Enable the Jansson-powered JSON parser.
    "--with-rsvg"                 # Enable SVG rendering.
    "--with-xml2"                 # Enable XML support.
    "--with-wide-int"             # Enable 64-bit integers no matter what.
  ];

  # NIX_CFLAGS_COMPILE = (oldAttrs.NIX_CFLAGS_COMPILE or "") + " " + cflags;
  env = (oldAttrs.env or {}) // {
    NIX_CFLAGS_COMPILE = (oldAttrs.env.NIX_CFLAGS_COMPILE or "") + " " + cflags;
  };
})
