{pkgs-unstable, config, ...}:
let
haps = config.services.home-assistant.package.python.pkgs;
enhancedShutterCard = pkgs-unstable.callPackage ../../packages/home-assistant/enhanced-shutter-card.nix {};
wiserPackage = haps.callPackage ../../packages/home-assistant/wiser.nix {
  aiowiserheatapi = haps.callPackage ../../packages/home-assistant/aioWiserHeatAPI.nix {}; 
  };
in
{
  services.home-assistant = {
    enable = true;
    package = pkgs-unstable.home-assistant.overrideAttrs (oldAttrs: {
  doInstallCheck = false;
});
    config = {
      default_config = {};

      #lovelace.mode = "yaml";

      http = {
        server_host = "127.0.0.1";
        trusted_proxies = [ "127.0.0.1" ];
        use_x_forwarded_for = true;
      };    

    automation = [{
      alias = "Ouverture volets lever du soleil";
      description = "";
      trigger = [{
        platform = "sun";
        event = "sunrise";
        offset = "0";
      }];
      condition = [ ];
      action = [{
        service = "cover.open_cover";
        target = {
          entity_id = "cover.wiser_shutter_bureau_volets_control";
        };
      }];
      mode = "single";
      }];
    };
    
    customLovelaceModules = [
      enhancedShutterCard
      ];

    customComponents = [ 
      wiserPackage 
      ];

  };


  dashy.services.entry = [{
    title = "Hass";
    url = "https://hass.nixos/";}];

  services.nginx.virtualHosts."hass.nixos" = {
    enableACME = true;
    forceSSL = true;
    extraConfig = ''
      proxy_buffering off;
    '';
    locations."/" = {proxyPass = "http://127.0.0.1:8123";
      proxyWebsockets = true;
    };
  };

}
