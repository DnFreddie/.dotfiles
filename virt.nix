{ config, pkgs, ... }:

{
  # Docker
  virtualisation.docker.enable = true;
  virtualisation.docker.enableOnBoot = false;
  # Virtualization Machine
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [

ansible
docker-compose
openvpn
awscli
nmap
  ];
}

