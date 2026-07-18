{ config, pkgs, inputs, ... }:

{
  # ==========================================
  # greetd with tuigreet + UWSM
  # ==========================================
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --sessions /etc/wayland-sessions";
        user = "greeter";
      };
    };
  };

  # Keyboard layout (no longer needs xserver)
  console.keyMap = "us";

  # Suppress the "last login" noise on the greeter TTY
  environment.etc."issue".text = "";

  environment.etc."wayland-sessions/mango.desktop".text = ''
    [Desktop Entry]
    Name=Mango
    Comment=Mango Wayland Compositor
    Exec=${inputs.mangowm.packages.${pkgs.system}.mango}/bin/mango
    Type=Application
  '';
}