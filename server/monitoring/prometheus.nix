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
    { job_name = "qbittorrent_exporter";
      static_configs = [{
	targets = [ "127.0.0.1:8000" ];
      }];}
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
    "prometheus-qbitorrent-exporter" = {
      image = "ghcr.io/esanchezm/prometheus-qbittorrent-exporter";
      #ports = ["127.0.0.1:8091:8000"]; inutile en network host
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

  dashy.monitoring.entry = [
  { title = "Prometheus";
    url = "https://prometheus.nixos/";}
  ];

}
