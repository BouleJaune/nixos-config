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
    ];
  };

  services.dolibarr = {
    enable = true;
    domain = "dolibarr.nixos";
    nginx.serverName = "dolibarr.nixos";
    nginx.enableACME = true;
    nginx.forceSSL = true;
  };

  dashy.services.entry = [
    { title = "Octoprint";
    url = "https://octoprint.nixos/";}
    { title = "Kanboard";
    url = "https://kanboard.nixos/";}
    { title = "Dolibarr";
    url = "https://dolibarr.nixos/";}
    { title = "Vaultwarden";
    url = "https://vault.nixos/";}
    ];

  services.vaultwarden = {
    enable = true;
    config = {
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
    };
  };

  users.users.kanboard = {
    useDefaultShell = false;
    isNormalUser = true; 
    home = "/var/lib/kanboard";
    group = "kanboard";
  };
  users.groups.kanboard = {};
  
  virtualisation.oci-containers.containers = {
    "kanboard" = {
      image = "docker.io/kanboard/kanboard:latest";
      ports = ["127.0.0.1:3010:443"];
      volumes = ["/var/lib/kanboard/data:/var/www/app/data"];
      autoStart = true;
      podman.user = "kanboard";
    };
  };
}
