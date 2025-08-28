programs.tmux = {
  enable = true;
  terminal = "screen-256color"; # better colors
  clock24 = true;

  plugins = with pkgs.tmuxPlugins; [
    sensible
    yank
    resurrect
    continuum
  ];

  extraConfig = ''
    # TPM plugin manager
    set -g @plugin 'tmux-plugins/tpm'

    # Example plugins (you can add more)
    set -g @plugin 'tmux-plugins/tmux-sensible'
    set -g @plugin 'tmux-plugins/tmux-yank'
    set -g @plugin 'tmux-plugins/tmux-resurrect'
    set -g @plugin 'tmux-plugins/tmux-continuum'

    # Initialize TPM
    run '~/.tmux/plugins/tpm/tpm'
  '';
};
