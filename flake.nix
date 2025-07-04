{
description = " My NixOS Flake Config with Qtile" ;

 inputs = {
	#Home manager
	nixpkgs.url ="github:NixOS/nixpkgs/nixos-unstable";
	home-manager.url = "github:nix-community/home-manager";
	home-manager.inputs.nixpkgs.follows = "nixpkgs";
		
 	# NvChad helper
  	nix4nvchad.url = "github:nix-community/nix4nvchad";
  	nix4nvchad.inputs.nixpkgs.follows = "nixpkgs";
	};
 outputs = { self, nixpkgs, home-manager, ...}:
	 let
	 system = "x86_64-linux";
	 in {
 	 nixosConfigurations.zorin = nixpkgs.lib.nixosSystem {
		inherit system;
		modules = [
		 ./configuration.nix
		 home-manager.nixosModules.home-manager
		{
		 home-manager.useUserPackages = true;
		 home-manager.users.zorin = import ./home.nix;
		}
	       ];
	      };
	     };
 }
			
