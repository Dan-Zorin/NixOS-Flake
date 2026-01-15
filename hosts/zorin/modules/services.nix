{ config, pkgs, ... }:

{
  # Audio with PipeWire (modern replacement for PulseAudio)
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Bluetooth
  services.blueman.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };

  # Printing
  services.printing.enable = true;

  # Flatpak (optional)
  # services.flatpak.enable = true;

  # Locate/mlocate for finding files
  services.locate = {
    enable = true;
    package = pkgs.mlocate;
    localuser = null;
  };

  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Automatic system upgrades (optional, be careful!)
  # system.autoUpgrade = {
  #   enable = true;
  #   flake = "/home/zorin/nix-config";
  #   flags = [ "--update-input" "nixpkgs" ];
  #   dates = "weekly";
  # };

  # Enable flakes and nix-command
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  # D-Bus
  services.dbus.enable = true;

  # Polkit (for privilege escalation)
  security.polkit.enable = true;
}