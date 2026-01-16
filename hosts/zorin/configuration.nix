{ config, pkgs, ... }:

{
  imports = [
    # Hardware configuration
    ./hardware-configuration.nix

    # System modules
    ./modules/boot.nix
    ./modules/networking.nix
    ./modules/services.nix
    ./modules/virtualization.nix
    ./modules/nvidia.nix
    ./modules/sddm.nix
  ];

  # ==========================================
  # System Settings
  # ==========================================

  # Hostname
  networking.hostName = "zorin";

  # Timezone
  time.timeZone = "America/Panama";

  # Locale
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Console keymap
  console.keyMap = "us";

  # ==========================================
  # Display/Graphics
  # ==========================================

  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # XDG Desktop Portal
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
    ];
    config.common.default = "*";
  };

  # OpenGL/Graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # ==========================================
  # User Account
  # ==========================================

  users.users.zorin = {
    isNormalUser = true;
    description = "Dan Zorin";
    extraGroups = [
      "wheel"           # sudo access
      "networkmanager"  # network management
      "video"           # video devices
      "audio"           # audio devices
      "libvirtd"        # VMs
      "podman"          # containers
    ];
    shell = pkgs.fish;
  };

  # Enable fish system-wide
  programs.fish.enable = true;

  # ==========================================
  # System Packages (keep minimal!)
  # ==========================================


  environment.systemPackages = with pkgs; [
    # Essential tools only
    vim
    git
    wget
    curl
    htop

    # For Wayland/Hyprland
    wayland
    xwayland

    # Qt styling for Wayland
    qt5.qtwayland
    qt6.qtwayland
    libsForQt5.qt5ct
  ];

  # Qt theming
  environment.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
  };

  # ==========================================
  # Security & Permissions
  # ==========================================

  # Sudo settings
  security.sudo.wheelNeedsPassword = true;

  # Polkit (already in services.nix, but ensuring it's here)
  security.polkit.enable = true;

  # ==========================================
  # System Version
  # ==========================================

  system.stateVersion = "25.11";
}