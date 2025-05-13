{ config, pkgs, ... }:

{

  users.groups.music = {};
  users.groups.video = {};


  # samba server
  services.samba-wsdd.enable = true; # make shares visible for windows 10 clients
    services.samba = {
      enable = true;
      openFirewall = true;
      settings = {
        global = {
          "workgroup" = "MYGROUP";
          "netbios name" = "nixos";
          "security" = "user";
          "guest account" = "nobody";
        };
        "public" = {
          "path" = "/bigpool/media/";
          "browseable" = "yes";
          "read only" = "no";
          "guest ok" = "yes";
        };
      };
    };


  # Jellyfin
  users.users.jellyfin = {
    isSystemUser = true;
    extraGroups = [ "music" "video" ];
  };
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    group = "video";
    };
  services.jellyseerr.enable = true;


# Qbitorroent headless
  users.groups.qbit = {};
  users.users.qbit = {
    isSystemUser = true;
    createHome = true;
    home = "/var/lib/qbittorrent";
    extraGroups = [ "music" "video" ];
    group = "qbit"; };
  systemd = { 
    packages = [pkgs.qbittorrent-nox];
    services."qbittorrent-nox@qbit" = {
      enable = true;
      overrideStrategy = "asDropin";
      wantedBy = ["multi-user.target"];
    };
  };

  services.lidarr = {
    openFirewall = true;
    enable = true;
    group = "music";
  };

}
