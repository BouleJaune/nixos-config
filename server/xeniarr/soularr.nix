{config, ...}:
# Config diverses pour les *arr
# slskd + soularr + flaresolverr
{

  # TODO slskd env sops
  # TODO soularr add mkoption config
  # https://github.com/mrusse/soularr/blob/main/config.ini
  

  dashy.xeniarr.entry = [{
    title = "slskd";
    url = "https://slskd.nixos/";}];
     

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
      stalled_timeout = "1800";
    };
  };

}
