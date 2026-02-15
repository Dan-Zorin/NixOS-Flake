{ config, pkgs, ... }:

{
  # ==========================================
  # SDDM with UWSM Support
  # ==========================================
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;

    # Auto-login (INSECURE - only for single-user systems)
    autoLogin = {
      enable = true;
      user = "zorin";
      relogin = false;  # Don't auto-login after manual logout
    };
  };


  # Enable X11 for backwards compatibility (optional)
  services.xserver = {
    enable = true;

    # Keyboard layout
    xkb = {
      layout = "us";
      # variant = "";
    };
  };
}