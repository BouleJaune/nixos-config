{ config, pkgs, ... }:

# Qbitorroent headless

{
  users.users.qbit = {
    isSystemUser = true;
    createHome = true;
    home = "/var/lib/qbittorrent";
    extraGroups = [ "music" ];
    group = "video"; };

  systemd = { 
    packages = [pkgs.qbittorrent-nox];
    services."qbittorrent-nox@qbit" = {
      enable = true;
      overrideStrategy = "asDropin";
      wantedBy = ["multi-user.target"];
      serviceConfig.UMask = "002";
      #serviceConfig.ExecStartPre="${pkgs.coreutils-full}/bin/sleep 300";
      #serviceConfig.TimeoutStartSec="500";
    };
  };

  services.nginx.virtualHosts = {
      "torrent.nixos" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8080";
          extraConfig = ''
          proxy_set_header   X-Forwarded-Host  http://$host;
          '';
         };
      };
  };


  dashy.services.entry = [{
    title = "Qbittorrent";
    url = "https://torrent.nixos/";}];

}
