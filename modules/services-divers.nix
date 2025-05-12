{ config, pkgs, ... }:

{
   #octoprint
   nixpkgs.overlays = [(self: super: {
     octoprint = super.octoprint.override {
       packageOverrides = pyself: pysuper: {
         octoprint-firmwareupdater = pyself.buildPythonPackage rec {
           pname = "FirmwareUpdater";
           version = "1.14.0";
           src = self.fetchFromGitHub {
             owner = "OctoPrint";
             repo = "OctoPrint-FirmwareUpdater";
             rev = "${version}";
             sha256 = "sha256-CUNjM/IJJS/lqccZ2B0mDOzv3k8AgmDreA/X9wNJ7iY=";
           };
           propagatedBuildInputs = [ pysuper.octoprint ];
           doCheck = false;
         };
       };
     };
   })];

  services.octoprint = {
    enable = true;
    openFirewall = true;
    plugins = plugins: with plugins; [ themeify 
    # stlviewer octoprint-firmwareupdater 
    ];
        };

  services.dolibarr = {
    enable = true;
    domain = "dolibarr.nixos";
    nginx.serverName = "dolibarr.nixos";
    #nginx.listenAddresses = [ "127.0.0.1" ];
    nginx.enableACME = true;
    nginx.forceSSL = true;
        };

  services.vaultwarden = {
    enable = true;
    config = {
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
    };
  };

  # rootless this
  virtualisation.oci-containers.containers = {
    "planning-poker" = {
      image = "ghcr.io/boulejaune/planning-poker:main";
      ports = ["127.0.0.1:8015:8000"];
      volumes = ["planning-poker-data:/data"];
      environment = { virtual_host = "poker-planning.boulejaune.com"; };
      autoStart = true;
      };
    };

  # rootless this
  virtualisation.oci-containers.containers = {
    "kanboard" = {
      image = "docker.io/kanboard/kanboard:latest";
      ports = ["127.0.0.1:3010:443"];
      volumes = ["kanboard_data:/var/www/app/data"];
      autoStart = true;
      };
    };

}