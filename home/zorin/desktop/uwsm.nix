{ config, pkgs, inputs, ... }:

{
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
  '';
}