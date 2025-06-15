{config, pkgs, ...}:
{
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

  dashy.xeniarr.entry = [
    { title = "Jellyfin";
    url = "https://jellyfin.nixos/";}
    { title = "Jellyseerr";
    url = "https://jellyseerr.nixos/";}];




  services.nginx.virtualHosts."jellyseerr.nixos" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {proxyPass = "https://127.0.0.1:5055";};
  };

  services.nginx.virtualHosts."jellyfin.nixos".locations."/" = {
    proxyPass = "http://127.0.0.1:8096";
    extraConfig = ''
      proxy_set_header   X-Forwarded-Host  http://$host;
    proxy_set_header   X-Real-IP   $remote_addr;
    '';
    proxyWebsockets = true;
  };

}
