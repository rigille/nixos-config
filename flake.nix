{
  description = "Rigille's personal flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    # unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  
  outputs = { self, nixpkgs, ... } @ inputs :
    let
      system = "x86_64-linux";
      hosts = [
        "rigille-workstation" # workstation
      ];
      defaultNixosSystem = host: nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
        ];
      };
    in {
      nixosConfigurations = builtins.listToAttrs 
        (map (host: {name = host; value = defaultNixosSystem host; }) hosts);
    };
}
