{...}:

{
  services.sonarr = {
      enable = true;
      group = "video";
      };
  
  services.nginx.virtualHosts."sonarr.nixos" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {proxyPass = "http://127.0.0.1:8989";};
      };

  dashy.xeniarr.entry = [{
    title = "Sonarr";
    url = "https://sonarr.nixos/";}];
 

}
