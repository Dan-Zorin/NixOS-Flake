{ config, pkgs, ... }:

{
  home.username = "zorin";
  home.homeDirectory = "/home/zorin";
  home.stateVersion = "24.05";

  # Enable fish shell
  programs.fish.enable = true;

  # Optional: set default shell
  # You should also set this in configuration.nix under users.users.zorin.shell
  # programs.zsh.enable = true;

  # File definitions (relative to flake root)
  home.file.".config/picom/picom.conf" = {
    source = ../../picom/picom.conf;
  };

  home.file.".config/ghostty/config" = {
    source = ../../ghostty/config;
  };

  home.file.".config/nvim" = {
    source = builtins.fetchGit {
      url = "https://github.com/NvChad/NvChad";
      rev = "main";  # Pin to a commit for reproducibility
    };
  };

  home.file.".config/qtile/config.py" = {
    source = ../../qtile/config.py;
  };

  # Optional autostart script
  # You can uncomment this if needed
  # home.file.".config/qtile/autostart.sh" = {
  #   source = ../../qtile/autostart.sh;
  #   executable = true;
  # };

  # Example: You can add starship or other programs here
  # programs.starship.enable = true;
}
