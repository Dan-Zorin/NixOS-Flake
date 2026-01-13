{
  description = "Dan Zorin's NixOS system with Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      # ------------------------------
      # NixOS System Configuration
      # ------------------------------
      nixosConfigurations.zorin = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
        };

        modules = [
          ./Host/nixos/system.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.zorin = import ./Home/zorin/home.nix;
          }
        ];
      };

      # Optional standalone Home Manager
      # homeConfigurations.zorin = home-manager.lib.homeManagerConfiguration {
      #   inherit pkgs;
      #   modules = [ ./Home/zorin/home.nix ];
      # };
    };
}

