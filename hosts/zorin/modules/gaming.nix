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

    # Font rendering fix
    fontPackages = with pkgs; [
      liberation_ttf
      wqy_zenhei
    ];

    # NOTE: removed the custom `package = pkgs.steam.override { ... }` block.
    # That override (added for protonhax experimentation) was preventing the
    # FHS rootfs build from including gameoverlayrenderer.so, which broke
    # Shift+Tab overlay in Proton games (e.g. tModLoader).
    #
    # If protonhax is revisited later, re-add a minimal override and verify
    # gameoverlayrenderer.so still exists in the resulting fhsenv-rootfs:
    #   find /nix/store/*-steam-*-fhsenv-rootfs/ -iname "*overlay*"
    #
    # Env vars that were here (DXVK_ASYNC, PROTON_ENABLE_NVAPI, GDK_BACKEND,
    # SDL_VIDEODRIVER, DISPLAY) are better set as per-game Launch Options:
    #   DXVK_ASYNC=1 PROTON_ENABLE_NVAPI=0 %command%
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
    heroic      # Epic Games & GOG
    # lutris      # Multi-platform game manager
    # bottles     # Windows games via Wine

    # Steam Tools for more advance tinker with games and variables
    protonplus
  ];

  # ==========================================
  #  Performance
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

}