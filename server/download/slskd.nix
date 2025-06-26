{config, ...}:

{

  # TODO scalpel api key

  dashy.xeniarr.entry = [{
    title = "slskd";
    url = "https://slskd.nixos/";}];
 
  systemd.services.slskd.serviceConfig.UMask = "002";
  services.slskd = {
    enable = true;
    domain = "slskd.nixos";
    nginx.enableACME = true;
    nginx.forceSSL = true;
    environmentFile = config.sops.secrets.slskd-env.path;
    group = "music";
    settings = {
      shares.directories = [ "/bigpool/media/Musics" ];
      directories.downloads = "/bigpool/media/slskd_download/Musics";
      directories.incomplete = "/bigpool/media/slskd_download";
      remote_file_management = true;
      web.authentication.api_keys.soularrkey = {
        key = "da0eed8a57798bb23634a389d5169061";
        cidr = "127.0.0.1/32";
      };
    };
  };

}
