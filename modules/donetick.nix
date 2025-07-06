{
  config,
    lib,
    pkgs,
    ...
}:

with lib;
let
cfg = config.services.donetick;
donetickPackage = pkgs.callPackage ../packages/donetick.nix {};
settingsFormat = pkgs.formats.yaml {};
configFile = settingsFormat.generate "selfhosted.yaml" cfg.settings;
in
{
  options = {

    services.donetick = {

      enable = mkEnableOption "donetick";
      package = mkOption {
        type = types.package;
        default = donetickPackage;
        description = "The donetick package to use.";
      };

      settings = mkOption {
        type =  settingsFormat.type;
        default = {
          name = "selfhosted";
          is_done_tick_dot_com = false;
          is_user_creation_disabled = false;
          telegram.token = "";
          pushover.token = "";
          database = {
            type = "sqlite";
            migration = true;
            # these are only required for postgres and not used
            host = "secret";
            port = 5432;
            user = "secret";
            password = "secret";
            name = "secret";
          };
          jwt = {
            secret = "definedinSopsEnv";
            session_time = "168h";
            max_refresh = "168h";
          };
          server = {
            port = 2021;
            read_timeout = "10s";
            write_timeout = "10s";
            rate_period = "60s";
            rate_limit = 300;
            cors_allow_origins = [
              "http://localhost:5173"
              "http://localhost:7926"
              "https://localhost"
              "capacitor://localhost"
            ];
            serve_frontend = true;
          };
          logging = {
            level = "info";
            encoding = "json";
            development = false;
          };
          scheduler_jobs = {
            due_job = "30m";
            overdue_job = "3h";
            pre_due_job = "3h";
          };
          email = {
            host = "";
            port = "";
            key = "";
            email = "";
            appHost = "";
          };
          oauth2 = {
            client_id = "";
            client_secret = "";
            auth_url = "";
            token_url = "";
            user_info_url = "";
            redirect_url = "";
            name = "";
          };
          realtime = {
            enabled = true;
            websocket_enabled = false;
            sse_enabled = true;
            heartbeat_interval = "60s";
            connection_timeout = "120s";
            max_connections = 1000;
            max_connections_per_user = 5;
            event_queue_size = 2048;
            cleanup_interval = "2m";
            stale_threshold = "5m";
            enable_compression = true;
            enable_stats = true;
            allowed_origins = [ "*" ];
          };
        };
        description = "Donetick yaml conf";
      };

      port = mkOption {
        type = types.port;
        default = 2021;
        description = "Port to run donetick on";
      };

      environmentFile = mkOption {
        type = types.path;
        description = "Environment variables file path";
      };
    };
  };

  config = mkIf cfg.enable {

    environment.etc."donetick/selfhosted.yaml" = {
      mode = "0600";
      source = configFile;
      user = "donetick";
      group = "donetick";
    };

# TODO variabiliser
    users.users.donetick = {
      useDefaultShell = false;
      isNormalUser = true; 
# TODO variabiliser
      home = "/var/lib/donetick";
      group = "donetick";
    };
    users.groups.donetick = {};

    virtualisation.oci-containers.containers = {
      "donetick" = {
        image = "donetick/donetick";
        ports = ["127.0.0.1:${toString cfg.port}:2021"];
        environmentFiles = [ cfg.environmentFile ];
        volumes = ["/etc/donetick:/config" "/var/lib/donetick:/donetick-data"];
        autoStart = true;
        podman.user = "donetick";
      };
    };

  };
}
