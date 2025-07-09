{ config, pkgs, ... }:

{
  
  # conf proton:
  # ip rule add from 10.2.0.2/32 lookup 42
  # ajout table 42 et enlever dns
  # ip route add 10.2.0.1 dev wg-proton
  networking.wg-quick.interfaces.wg-proton = {
    autostart = true;
    configFile = "/etc/wireguard/wg-proton.conf"; # [TODO] change  
  };

  dashy.services.entry = [
    # { title = "Home Assistant";
    # url = "https://hass.nixos/";}
    { title = "Wireguard-ui";
    url = "https://wgui.nixos/";}
    { title = "Adguard Home";
    url = "https://adguard.nixos/";}
    ];

  networking.firewall.trustedInterfaces = [ "wg-proton" ];
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 443 80 53 ];
    allowedUDPPorts = [ 53 51820 ];
  };

  networking.nat.enable = true;
  networking.nat.externalInterface = "enp8s0";
  networking.nat.internalInterfaces = [ "wg0" ];

  networking.wg-quick.interfaces.wg0.configFile = config.services.wireguard-ui.configDir + "/wg0.conf";

# Set static if and default gateway
  networking.interfaces.enp8s0.ipv4.addresses = [ {
    address = "192.168.1.200";
    prefixLength = 24;
  } ];

  networking.defaultGateway = "192.168.1.254";

  services.adguardhome = {
    enable = true;
    port = 3000;
    settings = {
      trusted_proxies = "192.168.1.1, 127.0.0.1";
    };
  };
  # sécurisation adguard via systemd
  systemd.services.adguardhome.serviceConfig = { 
      ProtectSystem = "strict";
      PrivateDevices = "true";
      ProtectHome = "true";
      RestrictNamespaces = "true";
      ProtectClock = "true";
      BindReadOnlyPaths = "/etc"; 
      ProtectHostname = "true";
      ProtectKernelTunables = "true";
      ProtectKernelLogs = "true";
      UMask = "0077";
      ProtectControlGroups =  "true";
      ProtectProc = "true";
      NoNewPrivileges = "true";
      ProtectKernelModules = "true";
      SystemCallFilter = [ "@system-service" "~@privileged"];
      CapabilityBoundingSet=[ "~CAP_SYS_BOOT CAP_SYS_CHROOT CAP_BLOCK_SUSPEND CAP_CHOWN CAP_FSETID CAP_SETFCAP CAP_SETUID CAP_SETGID CAP_SETPCAP CAP_KILL " ];
      };

  security.acme.defaults.email = "thierry.amettler+acme@proton.me";
  security.acme.acceptTerms = true;

  # Nginx
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    virtualHosts = {

      "default.nixos" = {
        default = true;
        redirectCode = 300;
        enableACME = true;
        forceSSL = true;
      };

      "vault.nixos" = { 
        enableACME = true;
        forceSSL = true;
        locations."/" = {proxyPass = "http://127.0.0.1:8222"; 
        };};

      # "hass.nixos" = { 
      #   enableACME = true;
      #   forceSSL = true;
      #       extraConfig = ''
      #       set $test 0;
      #   if ( $host != "hass.nixos" ){
      #       set $test 1;
      #   }
      #   if ( $host != "www.hass.nixos" ){
      #       set $test 1$test;
      #   }
      #   if ( $test = 11 ){
      #       return 444; #CONNECTION CLOSED WITHOUT RESPONSE
      #   }
      #   '';
      #   locations."/" = {proxyPass = "http://127.0.0.1:8123";
      #   proxyWebsockets = true;
      #   };
      # };

       "wgui.nixos" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {proxyPass = "http://127.0.0.1:5012";};
      };

       "navidrome.nixos" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {proxyPass = "http://127.0.0.1:4533";};
      };

       "octoprint.nixos" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {proxyPass = "http://127.0.0.1:5000";
          proxyWebsockets = true; 
        };
      };

       "kanboard.nixos" = {
    	  enableACME = true;
          forceSSL = true;
          locations."/" = {proxyPass = "https://127.0.0.1:3010";};
      };

      "adguard.nixos" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:3000";
          extraConfig = ''
          proxy_set_header   X-Forwarded-Host  http://$host;
          proxy_set_header   X-Real-IP   $remote_addr;
          '';
          proxyWebsockets = true;
        };
      };
    };

  };

  services.wireguard-ui = {
    enable = true;
    port = 5012;
  };
  

}
