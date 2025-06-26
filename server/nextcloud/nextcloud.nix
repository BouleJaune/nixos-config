{config, pkgs, lib, ...}:

{


dashy.services.entry = [{
   title = "Nextcloud";
   url = "https://nextcloud.nixos/";}];


services.onlyoffice = {
  enable = true;
  hostname = "onlyoffice.nixos";
  port = 8984;
  # jwtSecretFile = "/etc/nixos/pass";
  jwtSecretFile = config.sops.secrets.nextcloud-jwt.path;
};


# ajout de la putain d'option dans le local.json en preexec start 2 d'onlyoffice pour sssl selfsigned
# services.CoAuthoring.requestDefaults.rejectUnauthorized: false
systemd.services.onlyoffice-docservice =
  let
    createLocalDotJson = pkgs.writeShellScript "onlyoffice-prestart2" ''
      umask 077
      mkdir -p /run/onlyoffice/config/
      cat >/run/onlyoffice/config/local.json <<EOL
{
  "services": {
    "CoAuthoring": {
      "requestDefaults": {
        "rejectUnauthorized": false
      }
    }
  }
}
EOL
    '';
  in
  {
    serviceConfig.ExecStartPre = [ createLocalDotJson ];
  };


services.nginx.virtualHosts.${config.services.onlyoffice.hostname} = {
  forceSSL = true;
  enableACME = true;
};

services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
  forceSSL = true;
  enableACME = true;
};

# Allow installation of unfree corefonts package
nixpkgs.config.allowUnfreePredicate = pkg:
  builtins.elem (lib.getName pkg) [ "corefonts" ];

fonts.packages = with pkgs; [
  corefonts
];

services.nextcloud = {
  enable = true;
  hostName = "nextcloud.nixos";

  # Need to manually increment with every major upgrade.
  package = pkgs.nextcloud31;

  # Let NixOS install and configure the database automatically.
  database.createLocally = true;

  # Let NixOS install and configure Redis caching automatically.
  configureRedis = true;

  # Increase the maximum file upload size to avoid problems uploading videos.
  maxUploadSize = "16G";
  https = true;

  autoUpdateApps.enable = true;
  extraAppsEnable = true;
  extraApps = with config.services.nextcloud.package.packages.apps; {
    inherit onlyoffice;

  };
  
  settings = {
    overwriteprotocol = "https";
    default_phone_region = "FR";
    };
  config = {
    dbtype = "sqlite";
    adminuser = "admin";
    adminpassFile = config.sops.secrets.nextcloud-admin.path;
  };
};
}
