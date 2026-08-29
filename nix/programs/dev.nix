{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    uv ty jupyter marimo
    rustc cargo clippy rust-analyzer
    go gopls
    nodejs
    ghc stack cabal-install haskell-language-server
    gfortran fortran-language-server
    luajit luarocks
    devenv gnumake gcc
    cmake pkg-config meson ninja
    jdk jre jdt-language-server gradle maven
    kotlin kotlin-language-server
    dart flutter
    android-tools heimdall
    qemu
  ];
}
