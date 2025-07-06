{ config, ...}:
{

  services.donetick.enable = true;
  services.donetick.environmentFile = config.sops.secrets.donetick-env.path;
  services.donetick.port = 2021;
  
  services.nginx.virtualHosts."donetick.nixos" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {proxyPass = "http://127.0.0.1:2021";};
  };

  dashy.services.entry = [
    { title = "Donetick";
    url = "https://donetick.nixos/";}
    ];
}
