{
  description = "Dan Zorin's NixOS system with Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, home-manager, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in {
        # DevShell or packages here if needed
      }
    ) // {
      nixosConfigurations.zorin = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./hosts/nixos/system.nix

          # Enable Home Manager as a NixOS module
          home-manager.nixosModules.home-manager

          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
	    #home-manager.backupFileExtension = "backup";
		
            # Your Home Manager user config
            home-manager.users.zorin = import ./users/zorin/home.nix;
          }
        ];
      };
    };
}
