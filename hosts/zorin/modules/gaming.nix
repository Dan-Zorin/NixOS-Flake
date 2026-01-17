{ config, pkgs, ... }:

{
  # ==========================================
  # Steam
  # ==========================================
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;

    # Steam with additional compatibility tools
    gamescopeSession.enable = true;

    # Extra compatibility tools
    extraCompatPackages = with pkgs; [
      proton-ge-bin  # GE-Proton for better game compatibility
    ];
  };

  # GameMode - Optimizes system performance for games
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 10;
      };
      custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
      };
    };
  };

  # ==========================================
  # Graphics & Performance
  # ==========================================

  # Enable 32-bit graphics for games
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Vulkan support
  hardware.graphics.extraPackages = with pkgs; [
    # Intel
    intel-media-driver
    intel-vaapi-driver
    libva-vdpau-driver
    libvdpau-va-gl

    # NVIDIA (if you have NVIDIA GPU)
    # Already covered in nvidia.nix
  ];

  hardware.graphics.extraPackages32 = with pkgs.pkgsi686Linux; [
    intel-vaapi-driver
  ];

  # ==========================================
  # Gaming Utilities (System Level)
  # ==========================================

  environment.systemPackages = with pkgs; [
    # Gamepad support
    antimicrox  # Map gamepad to keyboard/mouse

    # Performance monitoring
    mangohud    # In-game performance overlay
    goverlay    # GUI for MangoHud configuration

    # Game launchers (system level, or add to home packages)
    # heroic      # Epic Games & GOG
    # lutris      # Multi-platform game manager
    # bottles     # Windows games via Wine
  ];

  # ==========================================
  # Kernel & Performance
  # ==========================================

  # Kernel parameters for gaming
  boot.kernel.sysctl = {
    # Improve responsiveness
    "vm.swappiness" = 10;

    # Network optimizations
    "net.core.netdev_max_backlog" = 16384;
    "net.core.somaxconn" = 8192;
    "net.ipv4.tcp_fastopen" = 3;
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.ipv4.tcp_mtu_probing" = 1;
  };

  # ==========================================
  # Audio for Gaming
  # ==========================================

  # Low latency audio (already in services.nix via PipeWire)
  # Just ensure PipeWire is configured for low latency
  services.pipewire.extraConfig.pipewire = {
    "context.properties" = {
      "default.clock.rate" = 48000;
      "default.clock.quantum" = 512;
      "default.clock.min-quantum" = 512;
      "default.clock.max-quantum" = 512;
    };
  };

  # ==========================================
  # Firewall for Gaming
  # ==========================================

  # Common gaming ports (adjust as needed)
  networking.firewall = {
    allowedTCPPorts = [
      # Steam Remote Play
      27036 27037
    ];
    allowedUDPPorts = [
      # Steam Remote Play & In-Home Streaming
      27031 27036
    ];
  };

  # ==========================================
  # Wine for Windows Games
  # ==========================================

  # Enable Wine for running Windows games
  # (This is handled by Steam Proton, but useful for non-Steam games)
}