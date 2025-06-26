{ config, inputs, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules/default.nix
    ./server/default.nix
    ];

  # Secret management
  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/xenio/.config/sops/age/keys.txt";

    secrets.xenio-pwd= {
      neededForUsers = true;
    };
    secrets.slskd-env = {};
    secrets.natpmp-qbit-env = {};
    secrets.nextcloud-jwt = {
      owner = config.systemd.services.onlyoffice-docservice.serviceConfig.User;
    };
    secrets.nextcloud-admin = {};
    secrets.qbitorrent-exporter = {};
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

# Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" "zfs" ];
  boot.zfs.forceImportRoot = false;
  networking.hostId = "952a6e3b";

# Set time zone.
  time.timeZone = "Europe/Paris";

# Select internationalisation properties.
  i18n.defaultLocale = "fr_FR.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "fr";
  };

  users.mutableUsers = false;
  users.users.xenio = {
    hashedPasswordFile = config.sops.secrets.xenio-pwd.path;
    isNormalUser = true;
    extraGroups = [ "qemu-libvirtd" "libvirtd" "libvirt" "wheel" "docker" "music" "video" ]; 
  };

  security.sudo.enable = true;
  security.sudo.extraRules = [
  {  users = [ "xenio" ];
    commands = [
    { command = "ALL" ;
      options= [ "NOPASSWD" ]; 
    }];}
  ];


# Virtualisation options
  virtualisation.docker.enable = true;
  virtualisation.libvirtd = {
  enable = true;
  qemu = {
    package = pkgs.qemu_kvm;
    runAsRoot = true;
    swtpm.enable = true;
    ovmf = {
      enable = true;
      packages = [(pkgs.OVMF.override {
        secureBoot = true;
        tpmSupport = true;
      }).fd];
      };
    };
  };

  security.polkit.enable = true;

# List packages installed in system profile. 
  environment.systemPackages = with pkgs; [
    wget
    smartmontools
    avrdude
    tmux
    docker
    libgcc
    btop
    ranger
    win-virtio
    # secret management cli
    age
    sops
    libnatpmp
    tree
    neovim
  ];

environment = { variables = { EDITOR = "nvim"; SYSTEMD_EDITOR = "nvim"; VISUAL = "nvim"; }; }; 


# VSC server patch
programs.nix-ld.enable = true;

# neovim
programs.neovim.defaultEditor = true;

# git
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    config = {
      user.name = "BouleJaune";
      user.email = "amthierry81@live.fr";
    };
  };

# Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
    openFirewall = true;
  };

# Automatic upgrades avec reboot si nécessaire
  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "-L"
      ];
    rebootWindow = { lower = "01:00"; 
                     upper = "05:00"; };
    };

# Nettoyage auto
  nix = {
    gc = {
      automatic = true;
      options = "--max-freed 1G --delete-older-than 7d";
    };
  };


# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It's perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
