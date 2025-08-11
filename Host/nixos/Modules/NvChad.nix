{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    # Use a minimal init.vim that sources NvChad or just point to NvChad
    # We override neovim config to point to NvChad config folder

    # Make sure neovim is installed
    package = pkgs.neovim;

    # Post-install commands to setup NvChad automatically
    # Example shell commands to clone NvChad repo if it doesn't exist
    extraConfig = ''
      if [ ! -d ~/.config/nvim ]; then
        git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
      fi
    '';
  };
}
