{config, inputs, ...}:

{
# port hardcodé à 8000, issue :
# https://github.com/kittyandrew/grafana-to-ntfy/issues/25
  services.grafana-to-ntfy = {
    enable = true;
    settings = {
      ntfyBAuthPass = "/etc/nixos/test";
      ntfyUrl = "http://127.0.0.1:3126/grafana";
      bauthPass = config.sops.secrets.grafana-to-ntfy.path;
      bauthUser = "admin";
      ntfyBAuthUser = "grafana";
    };
  };

  sops.secrets.grafana-to-ntfy = {
    owner = config.systemd.services.grafana.serviceConfig.User;
    group = config.users.users.grafana.group;
    mode = "0440"; #make grafana to ntfy and grafana readers
    restartUnits = [ "grafana" "grafana-to-ntfy" ];
  };

  users.users.grafana-to-ntfy.extraGroups = [ "grafana" ];

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
          url = "http://localhost:8000";
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
