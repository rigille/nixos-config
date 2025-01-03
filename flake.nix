{
  description = "Rigille's personal flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    neovim.url = "github:rigille/neovim";
    mixrank.url = "git+ssh://git@gitlab.com/mixrank/mixrank";
  };
  
  outputs = { self, nixpkgs, mixrank, neovim, ... } @ inputs :
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
        ];
      };
    in {
      nixosConfigurations = builtins.listToAttrs 
        (map (host: {name = host; value = defaultNixosSystem host; }) hosts);
    };
}
