{ config, pkgs, ... }:

{
hardware.bluetooth.enable = true;
services.blueman.enable = true;
security.rtkit.enable = true;
services.pipewire = {
  enable = true;
  alsa.enable = true;
  alsa.support32Bit = true;
  pulse.enable = true;
  # If you want to use JACK applications, uncomment this
  #jack.enable = true;
};



services.tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 20;

       #Optional helps save long term battery health
       START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
       STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging

      };
};

   services.thermald.enable = true;

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
thermald

  ];
}

