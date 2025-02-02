# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 3;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  # Garbage Collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  }; 

  networking.hostName = "powernix"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;


  # Set your time zone.
  time.timeZone = "Asia/Dhaka";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "bn_BD";
    LC_IDENTIFICATION = "bn_BD";
    LC_MEASUREMENT = "bn_BD";
    LC_MONETARY = "bn_BD";
    LC_NAME = "bn_BD";
    LC_NUMERIC = "bn_BD";
    LC_PAPER = "bn_BD";
    LC_TELEPHONE = "bn_BD";
    LC_TIME = "bn_BD";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

# Add docker group
  users.groups.docker = {};

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.azhar = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "Azhar Ibn Mostafiz";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
     # thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    gcc
    git
    gnumake
    cmake
    git
    vim
    wget
    ispell
    inotify-tools
    # Programming Languages
    #Elixir
    elixir
    elixir-ls

    #Python
    python3
    pyright

    #typescript
    typescript-language-server

    # Go
    gopls

    #YAML
    yaml-language-server

    #PHP
    intelephense

    dbgate
    libvterm
    zapzap
    telegram-desktop
    devenv
    ripgrep
    zoom-us
    xdg-desktop-portal
    libreoffice
    blender
    audacity

    # nginx
    # mariadb
    php
    # wordpress

    inkscape
    gimp

  ];


  
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    source-code-pro
    lohit-fonts.bengali
  ];

services.flatpak.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
virtualisation.docker.enable = true;

# PostgreSQL
services.postgresql = {
  enable = true;
  ensureUsers = [
  ];
  ensureDatabases = ["nexus_dev"];

  initialScript = pkgs.writeText "init-sql-script" ''
'';
};


programs.npm.enable = true;


programs.zsh.enable = true;

# Mikrotik
programs.winbox.enable = true;

services.syncthing = {
  enable = true;
  openDefaultPorts = true;
  user = "azhar";
  dataDir = "/home/azhar";
}; 


networking.extraHosts = ''
  127.0.0.1 propovoice-dev.local
  127.0.0.1 test.local
'';

  services.nginx = {
    enable = true;
    virtualHosts = {
      "propovoice-dev.local" = {
        root = "/var/www/propovoice-dev";
        locations."/" = {
          index = "index.php index.html index.htm";
          tryFiles = "$uri $uri/ /index.php?$args";
        };
        locations."~ \\.php$" = {
          extraConfig = ''
            fastcgi_pass unix:${config.services.phpfpm.pools.wordpress.socket};
            fastcgi_index index.php;
          '';
        };
      };
    };
  };

services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    ensureDatabases = [ "wordpress" ];
    ensureUsers = [
      {
        name = "wordpress";
        ensurePermissions = {
          "wordpress.*" = "ALL PRIVILEGES";
        };
      }
    ];
  };

  services.phpfpm.pools = {
    wordpress = {
      user = "nginx";
      # group = "nginx";
      settings = {
        "listen.owner" = config.services.nginx.user;
        # "listen.group" = config.services.nginx.group;
        "pm" = "dynamic";
        "pm.max_children" = 5;
        "pm.start_servers" = 2;
        "pm.min_spare_servers" = 1;
        "pm.max_spare_servers" = 3;
      };
    };
  };


programs.obs-studio.enable = true;

# services.mautrix-whatsapp.enable = true;
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
  system.stateVersion = "24.11"; # Did you read the comment?
}
