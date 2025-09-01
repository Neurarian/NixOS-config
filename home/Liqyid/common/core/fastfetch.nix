{
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        padding = {
          top = 2;
          right = 2;
        };
      };
      display = {
        size = {
          binaryPrefix = "si";
        };
        color = "blue";
        separator = "   ";
      };
      modules = [
        {
          type = "custom";
          format = "┌─────────────── Hardware Information ───────────────┐";
        }
        {
          type = "cpu";
          key = "  󰻠";
        }
        {
          type = "gpu";
          key = "  󰍛";
          format = "{2}";
        }
        {
          type = "memory";
          key = "  󰑭";
        }
        {
          type = "disk";
          key = "  ";
          folders = "/:/data";
        }
        {
          type = "display";
          key = "  󰍹";
        }
        {
          type = "bluetooth";
          key = "  󰂯";
        }
        {
          type = "sound";
          key = "  ";
          format = "{2:-38} ({3})";
        }
        {
          type = "battery";
          key = "  ";
        }
        {
          type = "custom";
          format = "├─────────────── Software Information ───────────────┤";
        }
        {
          type = "title";
          key = "  ";
          format = "{1} @ {2}";
        }
        {
          type = "os";
          key = "  ";
        }
        {
          type = "kernel";
          key = "  ";
          format = "{1} {2}";
        }
        {
          type = "lm";
          key = "  󰧨";
        }
        {
          type = "wm";
          key = "  ";
        }
        {
          type = "shell";
          key = "  ";
        }
        {
          type = "terminal";
          key = "  ";
        }
        {
          type = "terminalfont";
          key = "  ";
        }
        {
          type = "packages";
          key = "  󰏖";
        }
        {
          type = "wifi";
          key = "  ";
          format = "{4}";
        }
        {
          type = "media";
          key = "  󰝚";
          format = "{1:-20} - {3:-10} ({5})";
        }
        {
          type = "locale";
          key = "  ";
        }
        {
          type = "uptime";
          key = "  󰅐";
        }
        {
          type = "custom";
          format = "└────────────────────────────────────────────────────┘";
        }
        {
          type = "colors";
          paddingLeft = 20;
          symbol = "circle";
        }
      ];
    };
  };
}
