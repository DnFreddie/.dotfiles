{ config, pkgs, ... }:

{
  programs.thunar.enable = true;
  programs.xfconf.enable = true;

  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];
  programs.direnv.enable = true;
  services.gvfs.enable = true; 
  services.tumbler.enable = true;

  environment.systemPackages = with pkgs; [
#GOlang
#------------------------------------------------------
    gnumake
    at
    sysstat
    sqlite
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
    python311Packages.pynvim  
    xclip
    vifm 
    tmux
  ];
}

