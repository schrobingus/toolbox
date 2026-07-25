{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    devenv
    gnumake gcc
    uv ty
    jdk jre jdt-language-server gradle maven
    kotlin kotlin-language-server
    cargo rustc clippy rust-analyzer
    go gopls
    dart flutter
  ];
}
