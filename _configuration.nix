{ lib, config, pkgs, ... }:

let
  customNeovim = import ./config/nvim/nvim.nix;
  unstableTarball = fetchTarball https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';

  # inherit (builtins)
  #   concatStringsSep;
in
  {
  system.stateVersion = "23.05";
  nix.nixPath = [ "nixos-config=$HOME/Documents/NicsOS/configuration.nix" ];

  nixpkgs.config.allowUnfree = true;

  imports = [ 
      /etc/nixos/hardware-configuration.nix

      # ./hardware-configuration.nix
      # /etc/nixos/cachix.nix
    ];

  
  # UI section
  programs.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
  };
  environment.sessionVariables.NIXOS_OZONE_WL = "1"; 


  # END OF UI SECTION


  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERMINAL = "wezterm";
  };


  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  networking.hostName = "NicsLaptopOS";


  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;


  # always use network manager instead of manually configuring wireless,
  # much more convenient
  networking.networkmanager.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";


  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };


  # sets timezone
  time.timeZone = "Africa/Johannesburg";


  # Enable CUPS to print documents.
  # services.printing.enable = true;


  # sound section, various alternatives commented out,
  # will probably move this into a separate folder at some point
  sound.enable = true;
  
  services.jack.loopback.enable = true;

  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    configFile = pkgs.runCommand "default.pa" {} ''
      sed 's/module-udev-detect$/module-udev-detect tsched=0/' \
      ${pkgs.pulseaudio}/etc/pulse/default.pa > $out
    '';
    #extraConfig = builtins.concatStringsSep "\n" [
      # discord audio stream fix
     # "load-module module-null-sink sink_name=Combined_Output"
    #  "sink_properties=device.description=Combined_Output"
    #  "load-module module-null-sink sink_name=Recorded_Sink"
    #  "sink_properties=device.description=Recorded_Sink"
     # "load-module module-loopback source=1 sink=Combined_Output" # source here is mic source num
     # "load-module module-loopback source=3 sink=Combined_Output"
      #"load-module module-loopback source=3 sink=GA104 High Definition Audio Controller Digital Stereo (HDMI)" # sink is name of headphone output
    #];
  };

  #security.rtkit.enable = true;
  #services.pipewire = {
  #  enable = true;
  #  alsa.enable = true;
  #  alsa.support32Bit = true;
  #  pulse.enable = true;
  #  # If you want to use JACK applications, uncomment this
  #  # jack.enable = true;
  #  config.pipewire = {
  #    "context.properties" = {
  #      #"link.max-buffers" = 64;
  #      "link.max-buffers" = 16; # version < 3 clients can't handle more than this
  #      "log.level" = 2; # https://docs.pipewire.org/page_daemon.html
  #      #"default.clock.rate" = 48000;
  #      #"default.clock.quantum" = 1024;
  #      #"default.clock.min-quantum" = 32;
  #      #"default.clock.max-quantum" = 8192;
  #    };
  #  };
  #};


  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nic = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      # "adbusers"
    ]; # Enable ‘sudo’ for the user.
  };


  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
    }))
    # vsSetup
  ];


  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };


  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [

    # dev env
    neovim-nightly
    zsh
    git
    nixFlakes
    # unstable.vscode-with-extensions

    # languages, compilers and lsp
    ghc cabal-install cabal2nix # unstable.haskell-language-server stack
      # haskellPackages.ghcup haskellPackages.QuickCheck 
    lua
    gcc
    rnix-lsp

    # util
    pciutils
    usbutils
    xclip
    unzip
    unrar
    wget
    zip
    gparted
    cachix
    openssl
    dialog
    networkmanager
    wirelesstools
    lshw
    # etcher
    # systemd
    # jq

    # phone
    gitRepo

    # storage related
    btrfs-progs

    # terminal
    ripgrep
    unstable.alacritty
    zsh-autosuggestions
    unstable.foot
    wezterm

    # WM
    # rofi
    # (unstable.polybar.override {
      # i3GapsSupport = true;
      # alsaSupport = true;
    # })
    tofi

    # graphics related
    # nvidia-offload
    unstable.vulkan-tools
    # autorandr
    
    # logitech wireless software
    solaar
    
    # general use
    google-chrome
    qutebrowser
    slack
    spotify
    discord
    libreoffice
    # scrot # screenshot
    # imagemagick # part of screenshot management

    # power management (no default power management in i3)
    tlp

    # UI

    # game
    unstable.lutris

    # sound
    pavucontrol
    # unstable.pipewire
    # unstable.helvum
    
    wofi
    neofetch
    # socat
    # jq
    # acpi
    # inotify-tools
    # bluez
    # brightnessctl
    # playerctl
    # networkmanager
    # imagemagick
    # gjs
    # gnome3.gnome-bluetooth
    # upower
    # gtk3
    # wl-clipboard
    # blueberry
    # polkit_gnome
    # eww-wayland
    # wl-gammactl
    # hyprpicker
    # swappy
    # wlsunset
  ];




  # binary caches and enabling flakes
  # just left the commented out ones here because I set them up in cachix and
  # will have to do that on new setups (might look into automating that except
  # for confidential passwords)
  nix = {
    settings = {
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        # "public-plutonomicon.cachix.org-1:3AKJMhCLn32gri1drGuaZmFrmnue+KkKrhhubQk/CWc="
        "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
        # "iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo="
      ];


      substituters = [
         "https://cache.nixos.org/"
         # "https://public-plutonomicon.cachix.org"
         "https://hydra.iohk.io"
         # "https://iohk.cachix.org"
      ];
    };

         # enabling nix flakes
    package = pkgs.nixFlakes;
    extraOptions = ''
        extra-experimental-features = nix-command flakes
    '';
  };



  # power management
  services.tlp.enable = true;


    
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;


  # use latest kernel (No need for newer features atm so commented out)
  # boot.kernelPackages = pkgs.linuxPackages_latest;

 
  # zsh config
  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
      ];
    };
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;
  };


  # Set zsh as default
  users.defaultUserShell = pkgs.zsh;


  fonts = {
    enableDefaultPackages = true;
    
    packages = with pkgs.unstable; [
      jetbrains-mono
      font-awesome
      material-icons
      material-design-icons
      nerdfonts
    ];

    fontconfig = {
      defaultFonts = {
        monospace = ["jetbrains-mono"];	
      };
    };
  };


  hardware.bluetooth.enable = true;

  # enable controller support in steam
  hardware.steam-hardware.enable = true;
  # enabled this way for proton
  programs.steam.enable = true;
  # uncrackle steam audio

  # environment variables, not using atm but leaving here as reference.
  # environment.variables.NVIM_LUA_SETTINGS = "/etc/nixos/config/nvim/lua";
  
  # neovim setup
  programs.neovim = customNeovim pkgs;

  # for league
  # boot.kernel.sysctl  = { "abi.vsyscall32" = 0; };

  # Nvidea drivers
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.nvidia = {
    # stable or beta are main ones to look at for nvidia kernals
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    modesetting.enable = true;

    prime = {
      # sync runs only on either gpu or integrated afaik
      sync.enable = true;
      # able to offload to gpu on the run
      # offload.enable = true;
      intelBusId = "PCI:00:02:0";
      nvidiaBusId = "PCI:01:00:0";
    };
  };

  # external monitor
#   specialisation = {
#    external-display.configuration = {
#      system.nixos.tags = [ "external-display" ];
#      hardware.nvidia.prime.offload.enable = lib.mkForce false;
#      hardware.nvidia.powerManagement.enable = lib.mkForce false;
#    };
#  };
}


