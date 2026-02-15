{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # ==========================================
    # Nix Tools
    # ==========================================

    # ==========================================
    # Terminal Tools
    # ==========================================
    eza           # Modern ls replacement
    bat           # Modern cat replacement
    ripgrep       # Modern grep (rg)
    fd            # Modern find
    fzf           # Fuzzy finder
    jq            # JSON processor
    yq            # YAML processor

    # System monitoring
    htop
    btop
    bottom        # btm

    # File management
    ranger        # TUI file manager

    # Archives
    unzip
    zip
    p7zip
    unrar

    # ==========================================
    # Development
    # ==========================================
    # IDEs
    jetbrains.idea-community  # IntelliJ IDEA Community (Free)
    # jetbrains.idea-ultimate  # IntelliJ IDEA Ultimate (Paid)


    # Version control
    git
    git-lfs
    # Build tools
    gcc
    gnumake
    cmake

    # Languages & runtimes (add what you need)
    # nodejs
    # python3
    # rustup
    # go

    # ==========================================
    # Network Tools
    # ==========================================
    wget
    curl
    rsync
    transmission_4-qt6

    # ==========================================
    # Wayland/Hyprland Utilities
    # ==========================================
    uwsm              # Universal Wayland Session Manager
    wl-clipboard      # Clipboard utilities (wl-copy, wl-paste)
    cliphist          # Clipboard history
    grim              # Screenshot tool
    slurp             # Region selector for screenshots
    swappy            # Screenshot editor

    # Notifications
    mako              # Notification daemon
    libnotify         # notify-send command

    # App launchers
    rofi              # App launcher (supports Wayland)
    # wofi            # Alternative launcher

    # File managers
    xfce.thunar                     # GUI file manager
    xfce.thunar-volman              # Removable media management
    xfce.thunar-archive-plugin      # Archive support
    xfce.thunar-media-tags-plugin   # Media tags
    file-roller                     # File Roller to compress and decompress

    # ==========================================
    # Fonts
    # ==========================================
    nerd-fonts.blex-mono
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    # ==========================================
    # Gaming
    # ==========================================
    # Game launchers
    heroic           # Epic Games & GOG launcher
    lutris           # Universal game launcher
    bottles          # Wine manager for Windows games
    prismlauncher    # Minecraft launcher

    # Game utilities
    gamemode         # Performance optimizer
    gamescope        # Gaming compositor
    mangohud         # Performance overlay
    goverlay         # MangoHud GUI configurator

    # Game controllers
    antimicrox       # Gamepad mapper
    # ==========================================
    # Media
    # ==========================================
    strawberry       # Music player
    vlc
                  # Video player
    # imv            # Image viewer
    # ==========================================
    # Productivity
    # ==========================================
    vivaldi  		
    # chromium
    # obsidian        # Notes
    discord
    betterdiscordctl
    # slack

    # ==========================================
    # Other utilities
    # ==========================================
    tree
    file
    which
    killall
    libxcb
    libxcb-cursor
    xorg.libX11
  ];
}
