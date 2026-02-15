{ config, pkgs, ... }:

{
  # UWSM wrapper for Hyprland
  # This wraps the existing Hyprland session

  # XDG autostart file to launch with UWSM
  xdg.configFile."autostart/uwsm-hyprland.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=UWSM Hyprland Wrapper
    Exec=${pkgs.uwsm}/bin/uwsm finalize
    X-GNOME-Autostart-enabled=true
    NoDisplay=true
  '';

  # UWSM environment configuration
  home.file.".config/uwsm/env".text = ''
    # Wayland environment variables
    export NIXOS_OZONE_WL=1
    export MOZ_ENABLE_WAYLAND=1
    export QT_QPA_PLATFORM=wayland;xcb
    export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    export SDL_VIDEODRIVER=wayland
    export _JAVA_AWT_WM_NONREPARENTING=1

    # NVIDIA (if you have NVIDIA GPU)
    export LIBVA_DRIVER_NAME=nvidia
    export GBM_BACKEND=nvidia-drm
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export WLR_NO_HARDWARE_CURSORS=1

    # XDG
    export XDG_SESSION_TYPE=wayland
    export XDG_CURRENT_DESKTOP=Hyprland
    export XDG_SESSION_DESKTOP=Hyprland
  '';

  # Fish shell integration
  programs.fish.loginShellInit = ''
    # Launch Hyprland with UWSM on TTY1
    if test (tty) = /dev/tty1
      exec uwsm start -F hyprland.desktop
    end
  '';
}