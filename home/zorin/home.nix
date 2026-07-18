{ config, pkgs, inputs, ... }:

{
  home.username = "zorin";
  home.homeDirectory = "/home/zorin";
  home.stateVersion = "25.11";

  # Import modular configurations
  imports = [
  # Inputs
    inputs.spicetify-nix.homeManagerModules.spicetify

    # Desktop environment and wrappers
    ./desktop/mango.nix
    ./desktop/quickshell.nix
    ./desktop/theme.nix
    ./desktop/spicetify.nix
    ./desktop/kdeconnect.nix
    ./desktop/polkit.nix
    ./desktop/uwsm.nix

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
    BROWSER = "vivaldi-stable";
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland;xcb";  # Try Wayland first, fallback to X11
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };

  # Let Home Manager manage itself
  programs.home-manager.enable = true;
}