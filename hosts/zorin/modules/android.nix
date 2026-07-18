{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.android_sdk.accept_license = true;

  virtualisation.libvirtd.enable = true;
  users.users.zorin.extraGroups = [ "kvm" "libvirtd" ];

  environment.systemPackages = with pkgs; [
    android-studio
  ];
}