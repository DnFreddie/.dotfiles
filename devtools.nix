{ config, pkgs, ... }:

{
  programs.thunar.enable = true;
  programs.xfconf.enable = true;

  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];

  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  environment.systemPackages = with pkgs; [
    unzip
    ripgrep
    curl
    wget
    feh
    gh
    fzf
    tree
    bat
    python3
    pciutils
    python311Packages.pynvim  # Ensure this matches the exact attribute name in pkgs
    xclip
    vifm 
    tmux
  ];
}

