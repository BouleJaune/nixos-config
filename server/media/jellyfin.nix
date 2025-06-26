{...}:
{
  users.users.jellyfin = {
    isSystemUser = true;
    extraGroups = [ "music" "video" ];
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
    group = "video";
    };

  dashy.services.entry = [
    { title = "Jellyfin";
    url = "https://jellyfin.nixos/";}
    ];

  services.nginx.virtualHosts."jellyfin.nixos" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8096";
      extraConfig = ''
        proxy_set_header   X-Forwarded-Host  http://$host;
        proxy_set_header   X-Real-IP   $remote_addr;
      '';
      proxyWebsockets = true;
    };
  };

}
