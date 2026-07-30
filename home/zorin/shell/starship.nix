{ config, pkgs, ... }:

{
  programs.starship = {
    enable = true;
    enableNushellIntegration = true;

    settings = {
      # Add new line before prompt
      add_newline = true;

      # Format
      format = "$all";

      # Character
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };

      # Directory
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
        style = "bold cyan";
      };

      # Git
      git_branch = {
        symbol = " ";
        style = "bold purple";
      };

      git_status = {
        ahead = "⇡\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        behind = "⇣\${count}";
        style = "bold yellow";
      };

      # Languages
      nix_shell = {
        symbol = " ";
        format = "via [$symbol$state]($style) ";
      };

      nodejs = {
        symbol = " ";
        format = "via [$symbol($version )]($style)";
      };

      python = {
        symbol = " ";
        format = "via [$symbol$pyenv_prefix($version )]($style)";
      };

      rust = {
        symbol = " ";
        format = "via [$symbol($version )]($style)";
      };

      # Duration
      cmd_duration = {
        min_time = 500;
        format = "took [$duration]($style) ";
      };

      # Time
      time = {
        disabled = false;
        format = "🕙[$time]($style) ";
        time_format = "%T";
      };
    };
  };
}