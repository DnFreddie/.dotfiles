{ config, pkgs, ... }:

{
  # TODO please change the username & home direcotry to your own
  home.username = "hypr";
  home.homeDirectory = "/home/hypr";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  home.file."scripts" = {
     source = ./dotfiles/scripts;
     recursive = true;   # link recursively
     executable = true;  # make all files executable
   };
  home.file.".config/i3" = {
     source = ./dotfiles/i3;
     recursive = true;   # link recursively
     executable = true;  # make all files executable
   };

  home.file.".themes" = {
     source = ./dotfiles/.themes;
     recursive = true;   
   }; 
  home.file.".config/alacritty" = {
     source = ./dotfiles/alacritty;
     recursive = true;   
   }; 

  home.file.".config/dunst" = {
     source = ./dotfiles/dunst;
     recursive = true;   
   }; 

  home.file.".config/nvim" = {
     source = ./dotfiles/nvim;
     recursive = true;   
   }; 

  home.file.".config/picom" = {
     source = ./dotfiles/picom;
     recursive = true;   
   }; 

  home.file.".config/polybar" = {
     source = ./dotfiles/polybar;
     recursive = true;   
   }; 


  home.file.".config/vifm" = {
     source = ./dotfiles/vifm;
     recursive = true;   
   }; 


  home.file."Pictures/wallpapers" = {
     source = ./dotfiles/walppaers;
     recursive = true;   
   }; 

  home.file.".bashrc" = {
     source = ./dotfiles/.bashrc;
     recursive = true;   
   }; 
  home.file.".inputrc" = {
     source = ./dotfiles/.inputrc;
     recursive = true;   
   }; 

  home.file.".tmux.conf" = {
     source = ./dotfiles/.tmux.conf;
     recursive = true;   
   }; 














  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # here is some command line tools I use frequently
    # feel free to add your own or remove some of them

    # archives
    zip
    xz
    unzip
    p7zip
    # utils
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processer https://github.com/mikefarah/yq
    # networking tools
    dnsutils  # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    alacritty
    brave
    keepassxc
    # misc
    cowsay
    file
    which
    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files
    # system tools
    ethtool
    pciutils # lspci
    usbutils # lsusb
  ];

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "DnFreddie";
    userEmail = "defnotfreddie@gmail.com";
  };
  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
