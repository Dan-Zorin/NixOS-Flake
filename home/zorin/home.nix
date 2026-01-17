{ config, pkgs, ... }:

{
  home.username = "zorin";
  home.homeDirectory = "/home/zorin";
  home.stateVersion = "25.11";

  # Import modular configurations
  imports = [
    # Desktop environment
    ./desktop/hyprland.nix
    ./desktop/quickshell.nix
    ./desktop/theme.nix
    ./desktop/kdeconnect.nix

    # Shell & terminal
    ./shell/fish.nix
    ./shell/tmux.nix
    ./shell/starship.nix
    ./shell/kitty.nix

    # Development
    ./dev/git.nix

    # Editors
    # ./editors/nvim.nix

    # Package list
    ./packages.nix
  ];

  # Wayland session variables
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };

  # Let Home Manager manage itself
  programs.home-manager.enable = true;
}