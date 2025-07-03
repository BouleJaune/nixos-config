{ config, lib, pkgs, ... }:

with lib;

let
  script = pkgs.writeShellScript "update-natpmp-port" ''
    #!/usr/bin/env bash
    set -euo pipefail

    source ${config.services.natpmpQbit.envFile}

    PORT=$(${pkgs.libnatpmp}/bin/natpmpc -g "$GATEWAY" -a 1 0 tcp "$DURATION" | ${pkgs.gawk}/bin/awk '/Mapped public port/ {print $4}')
    if [[ -z "$PORT" ]]; then exit 1; fi
    echo "##### Found $PORT ######"

    COOKIEJAR=$(mktemp)
    ${pkgs.curl}/bin/curl -s -c "$COOKIEJAR" --data "username=$QBIT_USER&password=$QBIT_PASS" "$QBIT_HOST/api/v2/auth/login" > /dev/null
    ${pkgs.curl}/bin/curl -s -b "$COOKIEJAR" --data-urlencode "json={\"proxy_type\":0}" "$QBIT_HOST/api/v2/app/setPreferences"
    ${pkgs.curl}/bin/curl -s -b "$COOKIEJAR" --data-urlencode "json={\"listen_port\":$PORT}" "$QBIT_HOST/api/v2/app/setPreferences"
    rm "$COOKIEJAR"
  '';
in {

  options = { 

    services.natpmpQbit = {

      enable = mkEnableOption "natpmpQbit";

      envFile = mkOption {
        type = types.path;
        default = "/etc/natpmp-qbit.env";
        description = "Path to env file with QBIT_USER, QBIT_PASS, QBIT_HOST, GATEWAY, DURATION";
      };

    };
  };

  config = mkIf config.services.natpmpQbit.enable {
    environment.systemPackages = [ pkgs.libnatpmp pkgs.curl ];

    systemd.services.natpmpQbit = {
      description = "NAT-PMP port updater for qBittorrent";
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${script}";
      };
    };

    systemd.timers.natpmpQbit = {
      description = "Run NAT-PMP port update every 30s";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "50s";
        OnUnitInactiveSec = "30s";
        Persistent = true;
      };
    };
  };
}
