{config, ...}:

let
  slskdConf = config.services.slskd.settings;
  lidarrPort = config.services.lidarr.settings.server.port;

in
{


  services.soularr = {
    enable = true;
    settings = {
      Lidarr = {
        api_key = "8a127db029cb414789848ebdde01eafd";
        host_url = "http://127.0.0.1:${toString lidarrPort}";
        download_dir = slskdConf.directories.downloads;
      };
      Slskd = {
        api_key = slskdConf.web.authentication.api_keys.soularrkey.key;
        host_url = "http://127.0.0.1:${toString slskdConf.web.port}";
        url_base = "/";
        download_dir = slskdConf.directories.downloads;
        stalled_timeout = "1800";
      };
    };
  };

}
