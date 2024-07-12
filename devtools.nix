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
    libreoffice
    sshpass
    drawio
    gitleaks
    ispell
    pandoc
    lua
    tcpdump
    wireshark
    nmap
    iotop
    postgresql
    htop
    shellcheck
    pgcli
    brave
    chromium
    signal-desktop
    gnumake
    at
    libnotify  
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
    pciutils
    xclip
    vifm 
    tmux
  ];
}

