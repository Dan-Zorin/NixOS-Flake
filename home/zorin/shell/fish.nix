{ config, pkgs, ... }:

{
  programs.fish = {
    enable = true;

    shellInit = ''
      # Disable greeting
      set fish_greeting
    '';

    interactiveShellInit = ''
      # Auto-attach to tmux session
      if status is-interactive
          if not set -q TMUX
              tmux attach -t main || tmux new -s main
          end
      end

      # Wayland environment variables (if not set globally)
      set -x MOZ_ENABLE_WAYLAND 1
      set -x QT_QPA_PLATFORM wayland
      set -x SDL_VIDEODRIVER wayland
      set -x _JAVA_AWT_WM_NONREPARENTING 1
    '';

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

    functions = {
      # Custom function: quickly edit nix configs
      nixedit = "cd ~/Nix && $EDITOR .";

      # Custom function: search nix packages
      nixsearch = "nix search nixpkgs $argv";
    };
  };

  # Fish plugins (optional)
  # home.packages = with pkgs.fishPlugins; [
  #   done
  #   fzf-fish
  #   autopair
  # ];
}