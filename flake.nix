{
  description = "Dan Zorin's NixOS systems with Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-2511.url = "github:NixOS/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    mangowm.url = "github:mangowm/mango";
    mangowm.inputs.nixpkgs.follows = "nixpkgs";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      # ------------------------------
      # Per-host variables
      # ------------------------------

      hostVars = {
        zorin = {
          username = "zorin";
          fullName = "Dan Zorin";
          hostName = "zorin";
          homeDirectory = "/home/zorin";
          timeZone = "America/Panama";
          ddnsHost = "danzorin.ddns.net";
        };

        timothy = {
          username = "zorin";
          fullName = "Dan Zorin";
          hostName = "timothy";
          homeDirectory = "/home/zorin";
          timeZone = "America/Panama";
        };
      };

      mkHost = hostName: vars:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs vars; };
          modules = [
            # Main system configuration
            ./hosts/${hostName}/configuration.nix

            # Home Manager integration
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs vars; };
              home-manager.users.${vars.username} = import ./home/${vars.username}/home.nix;
              home-manager.backupFileExtension = "backup";
            }
          ];
        };
    in
    {
      # ------------------------------
      # NixOS System Configurations
      # ------------------------------
      # Produces nixosConfigurations.zorin and nixosConfigurations.timothy
      nixosConfigurations = nixpkgs.lib.mapAttrs mkHost hostVars;

      # ------------------------------
      # Standalone Home Manager
      # ------------------------------
      homeConfigurations.zorin = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs; vars = hostVars.zorin; };
        modules = [ ./home/zorin/home.nix ];
      };
    };
}
