{ lib, config, pkgs, ... }:

let
  customNeovim = import ./config/nvim/nvim.nix;
  i3setup = import ./config/i3/i3.nix;
  vsSetup = import ./config/vscode/vscode.nix;
  unstableTarball = fetchTarball https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./cachix.nix
    ];

    
  

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "NicsLaptopOS"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp7s0.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;
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
  

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the Plasma 5 Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;


  # enabling and configuring i3-gaps
  # services.xserver = i3setup pkgs;

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
  hardware.pulseaudio.configFile = pkgs.runCommand "default.pa" {} ''
      sed 's/module-udev-detect$/module-udev-detect tsched=0/' \
      ${pkgs.pulseaudio}/etc/pulse/default.pa > $out
  '';

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nic = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };




  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
    }))
    vsSetup
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
    unstable.vscode-with-extensions

    # languages, compilers and lsp
    ghc cabal-install cabal2nix unstable.haskell-language-server stack
      haskellPackages.ghcup haskellPackages.QuickCheck 
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
    nerdfonts


    # graphics related
    # nvidia-offload
    unstable.vulkan-tools
    autorandr

    
    # logitech wireless software
    solaar


    # general use
    google-chrome
    slack
    spotify
    discord
    libreoffice


    # game
    # unstable.wine
    # unstable.wine64
    # unstable.wine-staging
    unstable.lutris

    # sound
    # qpaeq
    ];

    # binary caches and enabling flakes
    nix = {
      binaryCaches = [
       # "https://cache.nixos.org/"
       # "https://public-plutonomicon.cachix.org"
       "https://hydra.iohk.io"
       # "https://iohk.cachix.org"
      ];

      binaryCachePublicKeys = [
        # "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        # "public-plutonomicon.cachix.org-1:3AKJMhCLn32gri1drGuaZmFrmnue+KkKrhhubQk/CWc="
        "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
        # "iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo="
      ];

      # enabling nix flakes
      package = pkgs.nixFlakes;
      extraOptions = ''
          extra-experimental-features = nix-command flakes
      '';
    };
    
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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?



  # use latest kernel (need to see if this is scuffed)
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # NicsOS (See what I did there?):

  # Set zsh as default
  users.defaultUserShell = pkgs.zsh;
  
  # ohmyzsh config
  programs.zsh = {
    ohMyZsh = {
      enable = true;
      plugins = ["git"];
    };
  };

  fonts = {
    enableDefaultFonts = true;

    fonts = with pkgs; [
      pkgs.jetbrains-mono
      pkgs.fira-code
    ];
  
    fontconfig = {
      defaultFonts = {
        monospace = ["jetbrains-mono"];	
      };
    };
  };

  # for vscode keyring
  services.gnome.gnome-keyring.enable = true;

  hardware.bluetooth.enable = true;

  # enable controller support in steam
  hardware.steam-hardware.enable = true;
  # enabled this way for proton
  programs.steam.enable = true;
  # uncrackle steam audio
  services.jack.loopback.enable = true;

  # environment variables, not using atm but leaving here as reference.
  # environment.variables.NVIM_LUA_SETTINGS = "/etc/nixos/config/nvim/lua";
  
  # neovim setup
  programs.neovim = customNeovim pkgs;

  # for league
  # boot.kernel.sysctl  = { "abi.vsyscall32" = 0; };

  # Nvidea drivers
  nixpkgs.config.allowUnfree = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.beta;

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


