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

  programs.swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;
      settings = {
        color = "2e3440";
        ignore-empty-password = true;
        indicator-caps-lock = true;

          screenshots = true;              # blur the actual desktop instead of solid color
          effect-blur = "7x5";
          effect-vignette = "0.5:0.5";
          clock = true;                    # show time on lock screen
          indicator = true;
          indicator-radius = 120;
          indicator-thickness = 10;
          ring-color = "3b4252";           # Nord palette
          ring-ver-color = "88c0d0";       # verifying (checking password)
          ring-wrong-color = "bf616a";     # wrong password (red-ish)
          ring-clear-color = "a3be8c";     # cleared
          key-hl-color = "88c0d0";
          text-color = "eceff4";
          text-clear-color = "2e3440";
          text-ver-color = "2e3440";
          text-wrong-color = "2e3440";
      };
    };

    services.swayidle = {
      enable = true;
      package = pkgs.swayidle;

      timeouts = [
        {
          timeout = 300; # 5 min
          command = "${pkgs.swaylock-effects}/bin/swaylock -f";
        }
        {
          timeout = 330; #
          command = "${pkgs.wlopm}/bin/wlopm --off \\*";
          resumeCommand = "${pkgs.wlopm}/bin/wlopm --on \\*";
        }
        {
          timeout = 900;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];

      events = [
        {
          event = "before-sleep";
          command = "${pkgs.swaylock-effects}/bin/swaylock -f";
        }
        {
          event = "lock";
          command = "${pkgs.swaylock-effects}/bin/swaylock -f";
        }
      ];
    };

    home.packages = with pkgs; [
      swayidle
      swaylock-effects
      wlopm
    ];
}