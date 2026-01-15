{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    historyLimit = 10000;
    keyMode = "vi";
    mouse = true;

    # Change prefix to Ctrl-a (like screen)
    # prefix = "C-a";

    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      vim-tmux-navigator
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavour 'mocha'
        '';
      }
    ];

    extraConfig = ''
      # Enable true color support
      set -ga terminal-overrides ",*256col*:Tc"
      set -as terminal-features ",xterm-256color:RGB"

      # Start windows and panes at 1, not 0
      set -g base-index 1
      setw -g pane-base-index 1

      # Renumber windows when one is closed
      set -g renumber-windows on

      # Split panes using | and -
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %

      # Reload config with r
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded!"

      # Vim-like pane switching
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Resize panes with Vim-like keys
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # Status bar position
      set -g status-position top

      # Don't rename windows automatically
      set -g allow-rename off
    '';
  };
}