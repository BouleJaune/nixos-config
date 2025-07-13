{config, ...}:

{


  services.prometheus = { 
    enable = true;
    scrapeConfigs = [
    { job_name = "node";
      static_configs = [{
	targets = [ "localhost:${toString config.services.prometheus.exporters.node.port}" ];
      }];}
    { job_name = "zfs_exporter";
      static_configs = [{
	targets = [ "127.0.0.1:9134" ];
      }];}
    { job_name = "smartctl_exporter";
      static_configs = [{
	targets = [ "127.0.0.1:9633" ];
      }];}
    { job_name = "restic_exporter";
      static_configs = [{
	targets = [ "127.0.0.1:8002" ];
      }];}
    { job_name = "ping_exporter";
      static_configs = [{
	targets = [ "127.0.0.1:9427" ];
      }];}
    { job_name = "qbittorrent_exporter";
      static_configs = [{
	targets = [ "127.0.0.1:8002" ];
      }];}
    ];
    alertmanagers = [
    {
      scheme = "http";
      static_configs = [{ targets = [ "localhost:9093" ]; }];
    }
    ];
  };

  services.nginx.virtualHosts."prometheus.nixos" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:9090";
      proxyWebsockets = true;
      recommendedProxySettings = true;
    };
  };

  users.users.qbitorrent-exporter = {
    isNormalUser = true; 
    useDefaultShell = false;
    home = "/var/lib/qbitorrent-exporter";
    group = "qbitorrent-exporter";
  };
  users.groups.qbitorrent-exporter = {};


  virtualisation.oci-containers.containers = {
    "prometheus_qbitorrent_exporter" = {
      image = "ghcr.io/esanchezm/prometheus-qbittorrent-exporter";
      environment = { EXPORTER_PORT = "8002";}; 
      #ports = ["127.0.0.1:8091:8000"]; #inutile en network host
      environmentFiles = [ config.sops.secrets.qbitorrent-exporter.path ];
      extraOptions = ["--network=host"];
      autoStart = true;
      podman.user = "qbitorrent-exporter";
    };
  };

  services.prometheus.exporters.node = {
    enable = true;
    port = 9100;
    enabledCollectors = [ "logind" "systemd" ];
    disabledCollectors = [ "textfile" ];
  };
  
  # default port 9134
  services.prometheus.exporters.zfs.enable = true;

  # default port 9633
  services.prometheus.exporters.smartctl = {
    enable = true;
    listenAddress = "127.0.0.1";
    };

  # default port 9427
  services.prometheus.exporters.ping = {
    enable = true;
    listenAddress = "127.0.0.1";
    settings = {
      targets = ["192.168.1.107"]; #WiserHeat
      };
    };

  dashy.monitoring.entry = [
  { title = "Prometheus";
    url = "https://prometheus.nixos/";}
  ];

}
