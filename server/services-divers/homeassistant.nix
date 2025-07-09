{...}:

{
  # services.home-assistant = {
  #   enable = true;
  #   config = null;
  # };


  dashy.services.entry = [{
    title = "Hass";
    url = "https://hass.nixos/";}];

  services.nginx.virtualHosts."hass.nixos" = {
    enableACME = true;
    forceSSL = true;
    extraConfig = ''
      set $test 0;
    if ( $host != "hass.nixos" ){
      set $test 1;
    }
    if ( $host != "www.hass.nixos" ){
      set $test 1$test;
    }
    if ( $test = 11 ){
      return 444; #CONNECTION CLOSED WITHOUT RESPONSE
    }
    '';
    locations."/" = {proxyPass = "http://127.0.0.1:8123";
      proxyWebsockets = true;
    };
  };

}
