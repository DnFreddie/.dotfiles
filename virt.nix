{ config, pkgs, ... }:

{
  # Docker
  virtualisation.docker.enable = true;

  # Virtualization Machine
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    polybar
    dunst
    rofi
    lxappearance
    picom
    arandr
    flameshot
    autotiling
  ];
}

