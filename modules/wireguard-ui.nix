{ config, pkgs, lib, ...}:

with lib;
let
	cfg = config.services.wireguard-ui;
in
{
options = {
  services.wireguard-ui = {

    enable = mkEnableOption	"wireguard-ui";
    package = mkOption {
      type = types.package;
      default = pkgs.wireguard-ui;
      description = "Package to use for wireguard-ui";
    };


    address = mkOption {
      type = types.str;
      default = "0.0.0.0";
      description = "Address on which to listen";
    };

    port = mkOption {
      type = types.port;
      default = 5000;
      description = "Port on which to listen";
    };

    configDir = mkOption {
      type = types.path;
      default = "/etc/wireguard";
      description = "Directory to store configuration and peers";
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/wireguard-ui";
      description = "Directory to store configuration and peers";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to open the firewall for the web UI";
    };
  };
  };

  config = mkIf cfg.enable {
    systemd.services.wireguard-ui = {
      description = "WireGuard UI Web Interface";
      wantedBy = [ "multi-user.target" ];
     after = [ "network.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/wireguard-ui  --bind-address ${cfg.address}:${toString cfg.port}";
        WorkingDirectory = cfg.dataDir;
        Restart = "always";
        User = "root";
      };
    };

    systemd.services.wgui = {
      description = "Restart WireGuard";
      after = [ "network.target" ];
      requiredBy = [ "wgui.path" ];
      
      serviceConfig = {
	Type = "oneshot";
	ExecStart = "${pkgs.systemd}/bin/systemctl restart wg-quick-wg0.service";
      };
    };
    
    systemd.paths.wgui = {
      description = "Watch ${cfg.configDir}/wg0.conf for changes";
      pathConfig.PathModified = "${cfg.configDir}/wg0.conf";	
      wantedBy = [ "multi-user.target" ];
    };


    environment.systemPackages = [ cfg.package ];

    # Create data and conf directories
    systemd.tmpfiles.rules = [
      "d ${cfg.configDir} 0755 root root"
      "d ${cfg.dataDir} 0755 root root"
    ];

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];
  };
}
