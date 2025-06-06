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
  }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        sops-nix.nixosModules.sops
      ];
      specialArgs.inputs = inputs;
    };
  };
}