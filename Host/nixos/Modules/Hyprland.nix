{ config, pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.hyprland
    pkgs.hyprpaper
    pkgs.waybar
    pkgs.wlr-randr
    pkgs.wlroots
    pkgs.quickshell
    pkgs.jq
    pkgs.dunst
    pkgs.flameshot
    pkgs.rofi
    pkgs.slurp
  ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  environment.etc."usr/share/wayland-sessions/hyprland.desktop".text = ''
    [Desktop Entry]
    Name=Hyprland
    Comment=Hyprland Wayland Session
    Exec=dbus-run-session Hyprland
    Type=Application
  '';
}

