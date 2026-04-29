{config, lib, inputs, ...}:

{
  # waiting : https://github.com/NixOS/nixpkgs/pull/503343
  disabledModules = [
    "services/monitoring/grafana-to-ntfy.nix"
  ];
  imports = [
    ../../modules/grafana-to-ntfy.nix
  ];

  services.grafana-to-ntfy = {
    enable = true;
    settings = {
      ntfyUrl = "http://127.0.0.1:3126/grafana";
      bauthPass = config.sops.secrets.grafana-to-ntfy.path;
      bauthUser = "admin";
      port = 8000;
    };
  };


  sops.secrets.grafana-to-ntfy = {
    owner = config.systemd.services.grafana.serviceConfig.User;
    group = config.users.users.grafana.group;
    mode = "0440"; #make grafana to ntfy and grafana readers
    restartUnits = [ "grafana" "grafana-to-ntfy" ];
  };

  users.users.grafana-to-ntfy = {
    isSystemUser = true;
    group = "grafana";
    };

  services.grafana.provision.alerting.contactPoints.settings = {
    apiVersion = 1;
    contactPoints = [
    {
      orgId = 1;
      name = "ntfy";
      receivers = [
      {
        uid = "berivnrt49ypsu";
        type = "webhook";
        settings = {
          httpMethod = "POST";
          password = "$__file{${config.sops.secrets.grafana-to-ntfy.path}}";
          url = "http://localhost:${toString config.services.grafana-to-ntfy.settings.port}";
          username = "admin";
        };
        disableResolveMessage = false;
      }
      ];
    }
    ];
  };

  services.grafana.provision.alerting.rules.path = "/etc/grafana/alerts/nixos-alerts.yaml";
  environment.etc."grafana/alerts/nixos-alerts.yaml" = {
    source = ./. + "/grafana-alerts/nixos-alerts.yaml";
    group = "grafana";
    user = "grafana";
  };

}  
