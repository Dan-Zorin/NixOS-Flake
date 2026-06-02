{ inputs, ... }:
let
  pkgs-2511 = import inputs.nixpkgs-2511 {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };
in
{
  environment.systemPackages = [
    pkgs-2511.duckstation
  ];
}