{ config, pkgs, inputs, ... }:

{
nixpkgs.config.allowUnfree = true;
  imports = [
    # Hardware configuration
    ./hardware-configuration.nix

    # System modules
    ./modules/boot.nix
    ./modules/amdgpu.nix
    ./modules/power.nix
    ./modules/services.nix
    ./modules/networking.nix
    ./modules/virtualization.nix
    ./modules/shotdown.nix
    ./modules/sddm.nix
    ./modules/avahi.nix
    ./modules/uwsm.nix

    # Dropped vs. zorin (desktop-only): gaming.nix, android.nix,
    # duckstation.nix, mount.nix, and service/{portainer,jellyfin-nginx,ds3}.nix.
    # Re-add any of these under ./modules/ or ./service/ if timothy ever needs them.
  ];

  # ==========================================
  # System Settings
  # ==========================================

  # Hostname
  networking.hostName = "timothy";

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

  # XDG Desktop Portal
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };

  # OpenGL/Graphics (AMD-specific bits live in modules/amdgpu.nix)
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
    inputs.mangowm.packages.${pkgs.system}.mango
    wayland
    xwayland

    # Qt styling for Wayland
    qt5.qtwayland
    qt6.qtwayland
    libsForQt5.qt5ct

    # Laptop-specific
    brightnessctl     # backlight control
    powertop          # power usage diagnostics
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
