{ config, pkgs, lib, ... }: 

let
  unstable = import
    (builtins.fetchTarball https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz)
    { config = config.nixpkgs.config; };
in
{
  services.xserver = {
    enable = true;
    
      
    desktopManager = {
      xterm.enable = false;
    };
    
    displayManager = {
      defaultSession = "none+i3";
    };
    
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;

      # gaps = {
      #  inner = 10;
      #  outer = 5;
      #};

      configFile = ./config/i3-config;
    
      extraPackages = with pkgs.unstable; [
        rofi
        # dmenu     # application launcher
        i3status-rust  # default i3 status bar
        i3lock    # i3 lock screen
        i3blocks  # for using i3blocks over i3status, needs some additional config, will come back to this later
        # polybar
      ];

      # config = rec {
      #  startup = [
      #   {
      #      command = "exec i3-msg workspace 1";
      #      always = true;
      #      notification = false;
      #    }
      #    {
      #      command = "systemctl --user restart polybar.service";
      #      always = true;
      #      notification = false;
      #    }
      #    {
      #      command = "slack";
      #      always = true;
      #      notification = false;
      #    }
      #  ];
      #};
    };
  };
}
