{
  description = "NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = { 
    self, 
    nixpkgs, 
    sops-nix, 
    nixpkgs-unstable, 
    ... 
  }@inputs:
  let
  system = "x86_64-linux";
  pkgs-unstable = import nixpkgs-unstable { inherit system; config.allowUnfree = true; };
  pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
  in
  {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      pkgs = pkgs;
      modules = [
        ./configuration.nix
        sops-nix.nixosModules.sops
      ];
      specialArgs = { 
        pkgs-unstable = pkgs-unstable;
        inputs = inputs;
        };
    };
  };
}
