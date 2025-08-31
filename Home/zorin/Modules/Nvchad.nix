{ config, pkgs, lib, ... }:

let
  nvchad = pkgs.fetchFromGitHub {
    owner = "NvChad";
    repo = "NvChad";
    rev = "v2.5"; # Pick a tag or commit
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };
in
{
  options.modules.nvchad = {
    enable = lib.mkEnableOption "Enable NvChad Neovim config";
    extraPlugins = lib.mkOption {
      type = with lib.types; listOf package;
      default = [ ];
      description = "Extra Neovim plugins to install on top of NvChad.";
    };
  };

  config = lib.mkIf config.modules.nvchad.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      plugins = config.modules.nvchad.extraPlugins;
    };

    # Declarative NvChad config
    home.file.".config/nvim".source = nvchad;
  };
}

