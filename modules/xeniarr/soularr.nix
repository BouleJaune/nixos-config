{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let

  cfg = config.services.soularr;
  soularrPackage = pkgs.callPackage ../../packages/soularr.nix {};
  settingsFormat = pkgs.formats.ini {};
  configFile = settingsFormat.generate "config.ini" cfg.settings;
in
{
  options = {

    services.soularr = {

      enable = mkEnableOption "soularr";
      package = mkOption {
        type = types.package;
        default = soularrPackage;
        description = "The Soularr package to use.";
      };


      downloadDir = mkOption {
        type = types.path;
        default = "/bigpool/media/slskd_download";
        description = ''
          The directory where soularr stores stuff.
        '';
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/soularr";
        description = ''
          The directory where soularr stores stuff.
        '';
      };

    interval = mkOption {
      type = types.str;
      default = "1min";
      example = "1min";
      description = ''
        Launch Soularr at regular intervals.
        The format is described in
        systemd.time(7).
      '';
    };

    settings = mkOption {
      type =  settingsFormat.type;
      default = {};
      description = "soularr ini conf";
      };

    };
  };

  ###### implementation

  config = mkIf cfg.enable {

    systemd.services.soularr = {
      after = [ "network.target" ];
      description = "Soularr";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        User = "soularr";
        ExecStartPre = ''
          /run/current-system/sw/bin/cp -u ${configFile} /var/lib/soularr/config.ini
        '';
        ExecStart = "${getExe cfg.package} --config-dir /var/lib/soularr";
        UMask = "002";
        StateDirectory = "soularr";
      };
    };

    systemd.timers.soularr = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnnbootSec = "15min";
        OnUnitInactiveSec = config.services.soularr.interval;
        Persistent = true;
      };
    };

    users = {
      users.soularr = {
        description = "Soularr user";
        home = cfg.dataDir;
        group = "music";
        isSystemUser = true;
      };
      #groups.soularr = { };
    };

  services.soularr.settings = {
    Logging = {
      level = mkDefault "INFO";
      format = mkDefault "[%(levelname)s|%(module)s|L%(lineno)d] %(asctime)s: %(message)s";
      datefmt = mkDefault "%Y-%m-%dT%H:%M:%S%z";
    };

    Slskd = {
      delete_searches = mkDefault "False";
      stalled_timeout = mkDefault 3600;
    };

    Lidarr = {
      disable_sync = mkDefault "False";
    };


    "Search Settings" = {
      search_timeout = mkDefault 5000;
      maximum_peer_queue = mkDefault 50;
      minimum_peer_upload_speed = mkDefault 0;
      minimum_filename_match_ratio = mkDefault 0.8;
      allowed_filetypes = mkDefault "flac 24/192,flac 16/44.1,flac,mp3 320,mp3";
      ignored_users = mkDefault "";
      search_for_tracks = mkDefault "True";
      album_prepend_artist = mkDefault "False";
      track_prepend_artist = mkDefault "True";
      search_type = mkDefault "incrementing_page";
      number_of_albums_to_grab = mkDefault 10;
      remove_wanted_on_failure = mkDefault "False";
      tittle_blacklist = mkDefault "";
      search_source = mkDefault "missing";
    };
    
    "Release Settings" = {
      use_most_common_tracknum = mkDefault "True";
      allow_multi_disc = mkDefault "True";
      accepted_countries = mkDefault "Europe,Japan,United Kingdom,United States,[Worldwide],Australia,Canada";
      accepted_formats = mkDefault "CD,Digital Media";
    };
  };

  };
}
