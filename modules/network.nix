{ config, pkgs, ... }:

{

  networking.firewall= {
    enable = false;
    allowedTCPPorts = [ 443 80 53 58051 58052 ];
    allowedUDPPorts = [ 1900 ];
  };

# Set static if and default gateway
  networking.interfaces.virbr1.ipv4.addresses = [ {
    address = "192.168.1.200";
    prefixLength = 24;
  } ];
  networking.bridges = {
    "virbr1" = {
      interfaces = [ "enp8s0" ];
    };
  };
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
      "default" = {
      default = true;
      redirectCode = 444;
      };

      "vault.nixos" = { 
        enableACME = true;
        forceSSL = true;
        locations."/" = {proxyPass = "http://127.0.0.1:8222"; 
        };};

      "hass.nixos" = { 
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

      "torrent.nixos".locations."/" = {
        proxyPass = "http://127.0.0.1:8080";
        extraConfig = ''
        proxy_set_header   X-Forwarded-Host  http://$host;
        '';
       };

       "poker-planning.boulejaune.com" = {
          locations."/" = {proxyPass = "http://127.0.0.1:8015";
	      proxyWebsockets = true;
          extraConfig = ''
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header Host $host;
              '';
            };
      };

       "prowlarr.nixos" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {proxyPass = "http://127.0.0.1:9696";};
      };

       "radarr.nixos" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {proxyPass = "http://127.0.0.1:7878";};
      };

       "navidrome.nixos" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {proxyPass = "http://127.0.0.1:4533";};
      };

       "octoprint.nixos" = {
        enableACME = true;
        locations."/" = {proxyPass = "http://127.0.0.1:5000";};
      };

       "kanboard.nixos" = {
    	  enableACME = true;
          forceSSL = true;
          locations."/" = {proxyPass = "https://127.0.0.1:3010";};
      };

      "jellyfin.nixos".locations."/" = {
        proxyPass = "http://127.0.0.1:8096";
        extraConfig = ''
        proxy_set_header   X-Forwarded-Host  http://$host;
        proxy_set_header   X-Real-IP   $remote_addr;
	    '';
	    proxyWebsockets = true;
      };

      "adguard.nixos".locations."/" = {
        proxyPass = "http://127.0.0.1:3000";
        extraConfig = ''
        proxy_set_header   X-Forwarded-Host  http://$host;
        proxy_set_header   X-Real-IP   $remote_addr;
        '';
        proxyWebsockets = true;
      };
    };
  };

}
