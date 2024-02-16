{config, pkgs, ... }:

{
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




environment.pathsToLink = [ "/libexec"];
services.xserver = { 
enable = true;
desktopManager = {
xterm.enable = false;
};
displayManager = {
defaultSession = "none+i3";
  sddm = { 
    enable = true;};

};

windowManager.i3 = {
enable = true;
};


};



}

