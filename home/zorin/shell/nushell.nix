{ config, pkgs, ... }:
{
  programs.nushell = {
    enable = true;
    shellAliases = {
      # Quick rebuilds
      hms = "home-manager switch --flake ~/Nix#zorin";
      nos = "sudo nixos-rebuild switch --flake ~/Nix#zorin";
      # Common aliases
      ls = "eza --icons";
      ll = "eza -l --icons";
      la = "eza -la --icons";
      tree = "eza --tree --icons";
      cat = "bat";
      grep = "rg";
      find = "fd";
      # Git shortcuts
      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git log --oneline --graph";
      # Quick navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
    };

    extraConfig = ''
      $env.config = {
        show_banner: false
      }

      # Custom command: quickly edit nix configs
      def nixedit [] {
        cd ~/Nix
        ^$env.EDITOR .
      }

      # Custom command: search nix packages
      def nixsearch [query: string] {
        nix search nixpkgs $query
      }

      if ($env.TMUX? | is-empty) {
          tmux new-session
      }
    '';
  };
}