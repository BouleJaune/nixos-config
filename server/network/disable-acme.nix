{config, ...}:

# Desac ceci à chaque nouveaux service
let
  virtualHosts = config.services.nginx.virtualHosts;
  domains = builtins.attrNames virtualHosts;
in {
  systemd.timers = builtins.listToAttrs (map (domain: {
    name = "acme-${domain}";
    value.enable = false;
  }) domains);
  systemd.services = builtins.listToAttrs (map (domain: {
    name = "acme-${domain}";
    value.enable = false;
  }) domains);
}
