{ pkgs, ... }:

{
	programs.neovim = {
  enable = true;
  extraConfig = ''
    if ! [ -d ~/.config/nvim ]; then
      git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
    fi
  '';
 };
}
