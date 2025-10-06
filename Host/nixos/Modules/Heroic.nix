{ config, pkgs, ... }:

{
  users.users.example = {
    isNormalUser = true;
    description = zorin;
    packages = with pkgs; [
      heroic
    ];
  };
}
