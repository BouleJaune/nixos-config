{config, pkgs, ...}:

{
  services.radarr = {
    enable = true;
    group = "video";
  };

  dashy.xeniarr.entry = [{
    title = "Radarr";
    url = "https://radarr.nixos/";}];

  services.nginx.virtualHosts."radarr.nixos" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {proxyPass = "http://127.0.0.1:7878";};
  };
}
