{ config, pkgs, ... }:

{
  # ==========================================
  # greetd with tuigreet + UWSM
  # ==========================================
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd 'uwsm start hyprland'";
        user = "greeter";
      };
    };
  };

  # Keyboard layout (no longer needs xserver)
  console.keyMap = "us";

  # Suppress the "last login" noise on the greeter TTY
  environment.etc."issue".text = "";
}