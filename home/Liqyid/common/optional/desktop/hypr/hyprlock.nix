{
  config,
  lib,
  ...
}:
{
  options = {
    desktop.hypr.hyprlock.enable = lib.mkEnableOption "enable hyprlock";
  };

  config = lib.mkIf config.desktop.hypr.hyprlock.enable {

    programs.hyprlock = {
      enable = true;
      settings = {
        source = "~/.config/hypr/hyprlock_colors.conf";
        general = {
          pam_module = "/etc/pam.d/hyprlock";
          disable_loading_bar = true;
          grace = 5;
          hide_cursor = true;
          no_fade_in = false;
        };

        background = [
          {
            path = "screenshot";
            blur_passes = 3;
            blur_size = 8;
          }
        ];

        label = [
          # TIME
          {
            monitor = "";
            text = ''cmd[update:30000] echo "$(date +"%I:%M %p")"'';
            color = "$text_color";
            font_size = 90;
            font_family = "JetBrainsMono NF";
            position = "-130 -100";
            halign = "right";
            valign = "top";
            shadow_passes = 2;
          }
          # DATE 
          {
            monitor = "";
            text = ''cmd[update:43200000] echo "$(date +"%A, %d %B %Y")"'';
            color = "$text_color";
            font_size = 25;
            font_family = "JetBrainsMono NF";
            position = "-130, -250";
            halign = "right";
            valign = "top";
            shadow_passes = 2;
          }
          # KEYBOARD LAYOUT
          {
            monitor = "";
            text = "$LAYOUT";
            color = "$text_color";
            font_size = 20;
            font_family = "JetBrainsMono NF";
            rotate = 0; # degrees, counter-clockwise
            position = "-130, -310";
            halign = "right";
            valign = "top";
            shadow_passes = 2;
          }
        ];

        image = [
          # USER AVATAR
          {
            monitor = "";
            path = "${builtins.toString ./.face}";
            size = 350;
            border_color = "$entry_border_color";
            rounding = -1;
            position = "0, 75";
            halign = "center";
            valign = "center";
            shadow_passes = 2;
          }
        ];
        input-field = [
          {
            monitor = "";
            size = "400, 70";
            position = "0, -185";
            dots_size = 0.2;
            dots_spacing = 0.2;
            dots_center = true;
            fade_on_empty = false;
            font_color = "$entry_color";
            inner_color = "$entry_background_color";
            outer_color = "$entry_border_color";
            outline_thickness = 4;
            placeholder_text = ''<i>󰌾 Logged in as </i>$USER'';
            shadow_passes = 2;
          }
        ];
      };
    };

    services.hypridle = {
      enable = true;
      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
          lock_cmd = "hyprlock";
        };

        listener = [
          {
            timeout = 300;
            on-timeout = "hyprlock";
          }
          {
            timeout = 360;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };
  };
}
