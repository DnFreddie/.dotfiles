{ config, pkgs, ... }:

{
hardware.bluetooth.enable = true;
security.rtkit.enable = true;
services.pipewire = {
  enable = true;
  alsa.enable = true;
  alsa.support32Bit = true;
  pulse.enable = true;
  # If you want to use JACK applications, uncomment this
  #jack.enable = true;
};


  services.sysstat.enable = true;

  programs.thunar.enable = true;
  programs.xfconf.enable = true;

  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];

  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images
  

  boot.kernel.sysctl = { "vm.swappiness" = 10;};


  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 4 * 1024; 
  }];



fonts.packages = with pkgs; [
     (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "Hack" ]; })
    comic-relief
    font-awesome_6
    fira
    jetbrains-mono
];


  environment.systemPackages = with pkgs; [
pavucontrol

  ];
}

