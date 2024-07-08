{config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    dunst
    rofi
    lxappearance
    picom
    arandr  
    flameshot
    vlc
    brave
    signal-desktop
  ];




environment.pathsToLink = [ "/libexec"];
services.xserver = { 
enable = true;
desktopManager = {
xterm.enable = false;
};
displayManager = {
defaultSession = "none+i3";
  gdm = { 
    enable = true;};

};

windowManager.i3 = {
enable = true;
};


};



}

