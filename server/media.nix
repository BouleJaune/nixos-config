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



# Qbitorroent headless
  users.users.qbit = {
    isSystemUser = true;
    createHome = true;
    home = "/var/lib/qbittorrent";
    extraGroups = [ "music" "video" ];
    group = "video"; };
  systemd = { 
    packages = [pkgs.qbittorrent-nox];
    services."qbittorrent-nox@qbit" = {
      enable = true;
      overrideStrategy = "asDropin";
      wantedBy = ["multi-user.target"];
      serviceConfig.UMask = "002";
    };
  };

  # Music server
  users.users.navidrome = {
    isSystemUser = true;
    extraGroups = [ "music" "video" ];
    group = "navidrome"; };
  services.navidrome = { 
    enable = true;
    settings = { 
      Address = "127.0.0.1";
      Port = 4533;
      MusicFolder = "/bigpool/media/Musics";
      EnableSharing = true;
    }; 
  };


}
