{ config, pkgs, ... }:

{
  services.natpmpQbit = {
    enable = true;
    envFile = config.sops.secrets.natpmp-qbit-env.path;
  };
}
