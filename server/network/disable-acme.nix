{config, ...}:

let
  virtualHosts = config.services.nginx.virtualHosts;
  domains = builtins.attrNames virtualHosts;
in {
  systemd.services = builtins.listToAttrs (map (domain: {
    name = "acme-${domain}";
    value.enable = false;
  }) domains);
}
