pkgs: {
  enable = true;
  
  videoDrivers = [ "nvidia" ];
  
  desktopManager = {
    xterm.enable = false;
  };
  
  displayManager = {
    defaultSession = "none+i3";
  };
  
  windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
  
    extraPackages = with pkgs; [
      dmenu     # application launcher
      i3status  # default i3 status bar
      i3lock    # i3 lock screen
      # i3blocks  # for using i3blocks over i3status, needs some additional config, will come back to this later
    ];
  };
}
