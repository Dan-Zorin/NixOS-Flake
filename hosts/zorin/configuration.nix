{ config, pkgs, ... }:

{
  imports = [
    # Hardware configuration
    ./hardware-configuration.nix

    # System modules
    ./modules/boot.nix
    ./modules/mount.nix
    ./modules/nvidia.nix
    ./modules/services.nix
    ./modules/networking.nix
    ./modules/virtualization.nix
    ./modules/shotdown.nix
    ./modules/sddm.nix
    ./modules/gaming.nix
    ./modules/android.nix
    ./modules/avahi.nix
    ./modules/duckstation.nix

    # System Services
    ./service/portainer.nix
    ./service/jellyfin-nginx.nix
    ./service/ds3.nix

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

  programs.uwsm.enable = true;
  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    withUWSM = true;
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
      "render"
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
    home-manager
    wireguard-tools

    # For Wayland/Hyprland
    wayland
    xwayland
    vencord
    # Hosting Tools only
    podman-compose


    # Qt styling for Wayland
    qt5.qtwayland
    qt6.qtwayland
    libsForQt5.qt5ct

    # Kernel Tools
    linuxKernel.packages.linux_xanmod_latest.cpupower # Performance power options for xanmod
  ];

  # Qt theming
  environment.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
    VENCORD_USER_DATA_DIR = "/home/zorin/.config/vesktop";
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
  
  system.stateVersion = "26.05";
}