{ config, pkgs, ... }:

{
  # Install UWSM system-wide
  environment.systemPackages = [ pkgs.uwsm ];

  # Create Hyprland-UWSM session file
  environment.etc."wayland-sessions/hyprland-uwsm.desktop".text = ''
    [Desktop Entry]
    Name=Hyprland (UWSM)
    Comment=Hyprland Wayland Compositor with UWSM
    Exec=uwsm start hyprland.desktop
    Type=Application
    DesktopNames=Hyprland
  '';
}