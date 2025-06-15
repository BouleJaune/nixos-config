{config, ...}:
# dashy
{
  services.dashy = {
    virtualHost.enableNginx = true;
    virtualHost.domain = "dashy.nixos";
    enable = true;
  };

  services.dashy.settings = {
    appConfig = {
      cssThemes = [
        "example-theme-1"
          "example-theme-2"
      ];
      enableFontAwesome = true;
      fontAwesomeKey = "e9076c7025";
      theme = "thebe";
    };
    pageInfo = {
      description = "My Awesome Dashboard";
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
        customStyles = "border: 2px dashed red;";
        itemSize = "large";
      };
      items =  config.dashy.xeniarr.entry;
      name = "Xeniarr";
    }
    ];
  };
  

}
