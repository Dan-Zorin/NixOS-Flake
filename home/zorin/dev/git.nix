{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;

    settings = {
      # User info
      user = {
        name = "Dan-Zorin";  # Change this
        email = "your@email.com";  # Change this
      };

      # Core settings
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;

      core = {
        editor = "nvim";  # or "vim" or your preferred editor
        autocrlf = "input";
      };

      # Colors
      color.ui = true;

      # Diff settings
      diff = {
        colorMoved = "default";
      };

      # Merge settings
      merge = {
        conflictStyle = "diff3";
      };

      # Rebase settings
      rebase = {
        autoStash = true;
      };

      # Aliases
      alias = {
        # Status
        st = "status";
        s = "status -sb";

        # Add
        a = "add";
        aa = "add --all";

        # Commit
        c = "commit";
        cm = "commit -m";
        ca = "commit --amend";
        can = "commit --amend --no-edit";

        # Branch
        b = "branch";
        ba = "branch -a";
        bd = "branch -d";

        # Checkout
        co = "checkout";
        cob = "checkout -b";

        # Log
        l = "log --oneline --graph --decorate";
        la = "log --oneline --graph --decorate --all";
        lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'";

        # Push/Pull
        p = "push";
        pf = "push --force-with-lease";
        pl = "pull";

        # Diff
        d = "diff";
        ds = "diff --staged";

        # Stash
        ss = "stash save";
        sp = "stash pop";
        sl = "stash list";

        # Undo
        unstage = "reset HEAD --";
        undo = "reset --soft HEAD^";
      };
    };
  };

  # Delta for better diffs
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      features = "side-by-side line-numbers decorations";
      syntax-theme = "Dracula";
    };
  };

  # Additional git tools
  home.packages = with pkgs; [
    lazygit  # TUI for git
    gh       # GitHub CLI
  ];
}