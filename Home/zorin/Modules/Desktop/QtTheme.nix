{ config, pkgs, lib, ... }:

{
  options.theme.qt.enable = lib.mkEnableOption "Enable Qt theming";

  config = lib.mkIf config.theme.qt.enable {
    environment.systemPackages = with pkgs; [
      kvantum
      kvantum-theme-nordic
      qt5ct
      qt6ct
    ];

    environment.variables = {
      QT_STYLE_OVERRIDE = "kvantum";  # Use Kvantum as Qt style engine
      QT_QPA_PLATFORMTHEME = "qt5ct"; # Works for Qt5+Qt6 apps under Nix
    };

    # Provide default Kvantum config (optional)
    xdg.configFile."Kvantum/kvantum.kvconfig".source =
      "${pkgs.kvantum-theme-nordic}/share/Kvantum/Nordic/Nordic.kvconfig";

    xdg.configFile."Kvantum/Nordic/Kvantum.kvconfig".source =
      "${pkgs.kvantum-theme-nordic}/share/Kvantum/Nordic/Nordic.kvconfig";
  };
}
