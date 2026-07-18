{
  description = "Dan Zorin's NixOS system with Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-2511.url = "github:NixOS/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    mangowm.url = "github:mangowm/mango";
    mangowm.inputs.nixpkgs.follows = "nixpkgs";
    inputs.spicetify-nix.url = "github:Gerg-L/spicetify-nix";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
         vars = {
              username = "zorin";
              fullName = "Dan Zorin";
              hostName = "zorin";
              homeDirectory = "/home/zorin";
              timeZone = "America/Panama";
              ddnsHost = "danzorin.ddns.net";
            };
    in
    {
      # ------------------------------
      # NixOS System Configuration
      # ------------------------------
      nixosConfigurations.zorin = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs vars; };
        modules = [
          # Main system configuration
          ./hosts/zorin/configuration.nix

          # Home Manager integration
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit vars; };
            home-manager.users.zorin = import ./home/zorin/home.nix;
            home-manager.backupFileExtension = "backup";
          }
        ];
      };

      # ------------------------------
      # Standalone Home Manager
      # ------------------------------
      homeConfigurations.zorin = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home/zorin/home.nix ];
      };
    };
}