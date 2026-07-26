{ config, pkgs, ... }:

{
  # GTK theme configuration
  dconf.enable = true;

  gtk = {
    enable = true;

    theme = {
      name = "Nordic";
      package = pkgs.nordic;
    };

    iconTheme = {
      name = "Nordzy";
      package = pkgs.papirus-nord;
    };

    cursorTheme = {
      name = "Nordzy cursor theme";
      package = pkgs.nordzy-cursor-theme;
      size = 24;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  # Qt theme to match GTK
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
  };

  # Pointer cursor
  home.pointerCursor = {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  home.packages = [
    (pkgs.writeShellScriptBin "set-wallpaper" (builtins.readFile ./dotfiles/scripts/set-wallpaper.sh))
    ];

  home.packages = with pkgs; [
      swww
      pywal16
      imagemagick
    ];

    systemd.user.services.swww-daemon = {
      Unit = {
        Description = "swww wallpaper daemon";
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.swww}/bin/swww-daemon";
        Restart = "on-failure";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };

    programs.kitty = {
      enable = true;
      settings = {
        allow_remote_control = "yes";
        listen_on = "unix:/tmp/kitty_pywal";
      };
    };
}