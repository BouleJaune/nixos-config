# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    #./home.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
 
  # Settings to get local builds but doesn't work
  #nix.settings.trusted-public-keys = [ "garyarch:/etc/nixos/public-nix-garyarch" ];

# Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

# Set your time zone.
  time.timeZone = "Europe/Paris";

# Select internationalisation properties.
  i18n.defaultLocale = "fr_FR.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "fr";
  };

# Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.xenio = {
    initialPassword = "1997"; # Initial password for first connection
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ and docker for the user.
  };
  security.sudo.enable = true;
  security.sudo.extraRules= [
  {  users = [ "xenio" ];
    commands = [
    { command = "ALL" ;
      options= [ "NOPASSWD" ]; 
    }
    ];
  }
  ];

  # Virtualisation options
  virtualisation.docker.enable = true;

# List packages installed in system profile. 
  environment.systemPackages = with pkgs; [
    wget
    docker
    qbittorrent-nox
    git
    libgcc
    #btop # cause a crash
    ranger
  ];

# samba server
  services.samba-wsdd.enable = true; # make shares visible for windows 10 clients
    services.samba = {
      enable = true;
      securityType = "user";
      extraConfig = ''
	workgroup = MYGROUP
	netbios name = nixos
	security = user
	guest account = nobody
	'';
      shares = {
	public = {
	  path = "/mnt/hdd/Vidéos";
	  browseable = "yes";
	  "read only" = "no";
	  "guest ok" = "yes";
	};
      };
    };

# Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };

# Qbitorroent headless
  systemd = {
    packages = [pkgs.qbittorrent-nox];
    services."qbittorrent-nox@xenio" = {
      overrideStrategy = "asDropin";
      wantedBy = ["multi-user.target"];
    };
  };

  services.vaultwarden = {
    enable = true;
    config = {
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
    };
  };

  services.adguardhome = {
    enable = true;
    settings = {
      trusted_proxies = "192.168.1.1, 127.0.0.1";
    };
  };


  security.acme.defaults.email = "thierry.amettler@proton.me";
  security.acme.acceptTerms = true;

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;

#forceSSL = true;
    virtualHosts = {
      "vault.nixos" = { 
	enableACME = true;
	forceSSL = true;
	locations."/" = {proxyPass = "http://127.0.0.1:8222"; 
	};};
      "hass.nixos" = { 
	enableACME = true;
	forceSSL = true;
	locations."/" = {proxyPass = "http://127.0.0.1:8123";
	  proxyWebsockets = true;
	};
      };
      "torrent.nixos".locations."/" = {proxyPass = "http://127.0.0.1:8080";
	extraConfig = ''
	  proxy_set_header   X-Forwarded-Host  http://$host;
	'';
      };
      "adguard.nixos".locations."/" = {proxyPass = "http://127.0.0.1:3001";
	extraConfig = ''
	  proxy_set_header   X-Forwarded-Host  http://$host;
	proxy_set_header   X-Real-IP   $remote_addr;
	'';
	proxyWebsockets = true;
      };
    };
  };

# Or disable the firewall altogether.
  networking.firewall.enable = false;
# Set static if and default gateway
  networking.interfaces.enp8s0.ipv4.addresses = [ {
    address = "192.168.1.200";
    prefixLength = 24;
  } ];
  networking.defaultGateway = "192.168.1.1";

# Copy the NixOS configuration file and link it from the resulting system
# (/run/current-system/configuration.nix). This is useful in case you
# accidentally delete configuration.nix.
# system.copySystemConfiguration = true;

# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It's perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}

