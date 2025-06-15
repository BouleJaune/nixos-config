{config, pkgs, ...}:
{

  # TODO https lidarr <=> qbtiorrent
  # user lidar + group
  services.lidarr = {
    openFirewall = true;
    enable = true;
    group = "music";
  };

  services.nginx.virtualHosts."lidarr.nixos".locations."/" = {
    proxyPass = "http://127.0.0.1:8686";
    extraConfig = ''
    proxy_set_header   X-Forwarded-Host  http://$host;
    '';
  };

  dashy.xeniarr.entry = [{
    title = "Lidarr";
    url = "https://lidarr.nixos/";}];
}
