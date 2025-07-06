{config, pkgs, lib, ...}:

{
  services.dashy = {
    virtualHost.enableNginx = true;
    virtualHost.domain = "dashy.nixos";
    enable = true;
  };

  services.nginx.virtualHosts."dashy.nixos" = {
    forceSSL = true;
    enableACME = true;
  };
  
  services.dashy.settings = {
    appConfig = {
      startingView = "minimal";
      cssThemes = [
        "example-theme-1"
          "example-theme-2"
      ];
      enableFontAwesome = true;
      fontAwesomeKey = "e9076c7025";
      theme = "thebe";
    };
    pageInfo = {
      description = "NixOS Home Server Dashboard";
      navLinks = [
      {
        path = "/";
        title = "Home";
      }
      ];
      title = "Dashy";
    };
    sections = [
    {
      displayData = {
        collapsed = false;
        cols = 2;
        #customStyles = "border: 2px dashed red;";
        itemSize = "large";
      };
      items =  config.dashy.xeniarr.entry;
      name = "Xeniarr";
    }
    {
      displayData = {
        collapsed = false;
        cols = 2;
        #customStyles = "border: 2px dashed red;";
        itemSize = "large";
      };
      items =  config.dashy.services.entry;
      name = "Services";
    }
    {
      displayData = {
        collapsed = false;
        cols = 2;
        #customStyles = "border: 2px dashed red;";
        itemSize = "large";
      };
      items =  config.dashy.monitoring.entry;
      name = "Monitoring";
    }
    ];
  };
  

}
