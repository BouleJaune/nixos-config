{ config, pkgs, ... }:
{
  services.prowlarr.enable = true;
  
  services.nginx.virtualHosts."prowlarr.nixos" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {proxyPass = "http://127.0.0.1:9696";};
      };

  dashy.xeniarr.entry = [{
    title = "Prowlarr";
    url = "https://prowlarr.nixos/";}];

}
