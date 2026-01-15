{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;

    font = {
      name = "BlexMono Nerd Font";
      size = 8;
    };

    settings = {
      # Theme
      include = "current-theme.conf";

      # Window
      background_opacity = "0.10";
      background_blur = 30;

      # Wayland-specific
      wayland_titlebar_color = "system";
      linux_display_server = "wayland";
      hide_window_decorations = "no";

      # Cursor
      cursor_shape = "block";
      cursor_blink_interval = 0;

      # Scrollback
      scrollback_lines = 10000;

      # Mouse
      url_color = "#0087bd";
      url_style = "curly";

      # Performance
      repaint_delay = 10;
      input_delay = 3;
      sync_to_monitor = "yes";

      # Bell
      enable_audio_bell = "no";
      visual_bell_duration = "0.0";

      # Window layout
      remember_window_size = "yes";
      initial_window_width = "640";
      initial_window_height = "400";

      # Tab bar
      tab_bar_edge = "bottom";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
    };

    # Keybindings
    keybindings = {
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+q" = "close_tab";
      "ctrl+shift+right" = "next_tab";
      "ctrl+shift+left" = "previous_tab";
      "ctrl+shift+equal" = "increase_font_size";
      "ctrl+shift+minus" = "decrease_font_size";
      "ctrl+shift+backspace" = "restore_font_size";
    };
  };

  # Theme file
 # home.file.".config/kitty/current-theme.conf" = {
 #   source = ../../../dotfiles/kitty/current-theme.conf;
  #};
}