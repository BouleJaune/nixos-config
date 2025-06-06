{config, ...}:
{
   # TODO https lidarr <=> qbtiorrent
   # user lidar + group
   services.lidarr = {
     openFirewall = true;
     enable = true;
     group = "music";
   };

    # TODO slskd env sops
    # TODO soularr add mkoption config
    # https://github.com/mrusse/soularr/blob/main/config.ini
  
    services.slskd = {
      enable = true;
      domain = "slskd.nixos";
      # environmentFile = ../slskd_env;
      environmentFile = config.sops.secrets.slskd-env.path;
      group = "music";
      settings = {
        shares.directories = [ "/bigpool/media/Musics" ];
        directories.downloads = "/bigpool/media/slskd_download/Musics";
        directories.incomplete = "/bigpool/media/slskd_download";
        remote_file_management = true;
        web.authentication.api_keys.soularrkey = {
          key = "da0eed8a57798bb23634a389d5169061";
          cidr = "0.0.0.0/0,::/0";
        };

      };
    };

  services.soularr.enable = true;
  services.soularr.settings = {
    Lidarr = {
      api_key = "8a127db029cb414789848ebdde01eafd";
      host_url = "http://lidarr.nixos";
      download_dir = config.services.slskd.settings.directories.downloads;
    };
    Slskd = {
      api_key = config.services.slskd.settings.web.authentication.api_keys.soularrkey.key;
      host_url = "http://slskd.nixos";
      url_base = "/";
      download_dir = config.services.slskd.settings.directories.downloads;
    };

  };
   
  services.nginx.virtualHosts."lidarr.nixos".locations."/" = {
       proxyPass = "http://127.0.0.1:8686";
       extraConfig = ''
       proxy_set_header   X-Forwarded-Host  http://$host;
       '';
      };

}
