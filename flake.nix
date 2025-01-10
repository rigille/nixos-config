{
  description = "Rigille's personal flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    neovim.url = "github:rigille/neovim";
    mixrank.url = "git+ssh://git@gitlab.com/mixrank/mixrank";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  
  outputs = { self, nixpkgs, mixrank, neovim, home-manager, ... } @ inputs:
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
          mixrank.nixosModules.dev-machine
          home-manager.nixosModules.home-manager
        ];
      };
    in {
      nixosConfigurations = builtins.listToAttrs 
        (map (host: {name = host; value = defaultNixosSystem host; }) hosts);
    };
}
