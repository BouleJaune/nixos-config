{ config, pkgs, ... }:

{

  users.groups.music = {};
  users.groups.video = {};

  # samba server
  services.samba-wsdd.enable = true;
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



  dashy.services.entry = [
    { title = "Navidrome";
    url = "https://navidrome.nixos/";}
    ];

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
