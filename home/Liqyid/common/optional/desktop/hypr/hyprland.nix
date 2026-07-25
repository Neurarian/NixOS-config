{
  config,
  lib,
  inputs,
  pkgs,
  system,
  ...
}: {
  options = {
    desktop.hypr.hyprland.enable = lib.mkEnableOption "enable hyprland";
  };

  config = lib.mkIf config.desktop.hypr.hyprland.enable {
    home.packages = [
      inputs.matshell.packages.${system}.default
      pkgs.hyprcursor
      pkgs.grimblast
      pkgs.catppuccin-cursors.macchiatoDark
      pkgs.glib
      pkgs.libnotify
      pkgs.playerctl
    ];

    wayland.windowManager.hyprland = let
      pointer = config.home.pointerCursor;
      cursorName = "catppuccin-macchiato-dark-cursors";
      mod = "SUPER";

      # Helper to reduce boilerplate for exec binds
      exec = cmd: lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${cmd}")'';

      workspaces = builtins.concatLists (
        builtins.genList (
          x: let
            c = (x + 1) / 10;
            wsKey = toString (x + 1 - (c * 10));
            ws = toString (x + 1);
          in [
            {_args = ["${mod} + ${wsKey}" (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = ${ws} })")];}
            {_args = ["${mod} + SHIFT + ${wsKey}" (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = ${ws} })")];}
          ]
        )
        10
      );
    in {
      enable = true;
      package = inputs.hyprland.packages.${system}.hyprland;
      systemd.enable = true;
      configType = "lua";
      importantPrefixes = [
        "$"
        "bezier"
        "curve"
        "name"
        "output"
        "colors"
      ];

      submaps.resize = {
        settings = {
          bind = [
            {_args = ["escape" (lib.generators.mkLuaInline ''hl.dsp.submap("reset")'')];}
            {_args = ["Return" (lib.generators.mkLuaInline ''hl.dsp.submap("reset")'')];}
            {_args = ["L" (lib.generators.mkLuaInline "hl.dsp.window.resize({ x = 40,  y = 0,   relative = true })") {repeating = true;}];}
            {_args = ["H" (lib.generators.mkLuaInline "hl.dsp.window.resize({ x = -40, y = 0,   relative = true })") {repeating = true;}];}
            {_args = ["K" (lib.generators.mkLuaInline "hl.dsp.window.resize({ x = 0,   y = -40, relative = true })") {repeating = true;}];}
            {_args = ["J" (lib.generators.mkLuaInline "hl.dsp.window.resize({ x = 0,   y = 40,  relative = true })") {repeating = true;}];}
          ];
        };
      };

      settings = {
        colors = {
          _var = lib.generators.mkLuaInline "require('hyprland_colors')";
        };
        mod = {_var = mod;};

        # Two-argument env: hl.env("KEY", "VALUE")
        env = [
          {_args = ["HYPRCURSOR_THEME" cursorName];}
          {_args = ["XCURSOR_THEME" cursorName];}
          {_args = ["HYPRCURSOR_SIZE" (toString pointer.size)];}
          {_args = ["XCURSOR_SIZE" (toString pointer.size)];}
        ];
        layer_rule = [
          {
            _args = [
              {
                match = {namespace = "bar";};
                blur = true;
              }
            ];
          }
          {
            _args = [
              {
                match = {namespace = "gtk4-layer-shell";};
                blur = true;
              }
            ];
          }
          {
            _args = [
              {
                match = {namespace = "bar";};
                xray = 1;
              }
            ];
          }
          {
            _args = [
              {
                match = {namespace = "bar";};
                ignore_alpha = 0.2;
              }
            ];
          }
          {
            _args = [
              {
                match = {namespace = "gtk4-layer-shell";};
                ignore_alpha = 0.2;
              }
            ];
          }
        ];
        window_rule = [
          {
            _args = [
              {
                match = {pin = 1;};
                border_color = lib.generators.mkLuaInline ''
                  { colors = { pinnedWindow, pinnedWindowGrad }, angle = 45 }
                '';
              }
            ];
          }
          {
            _args = [
              {
                match = {class = "com.github.th_ch.youtube_music";};
                workspace = 2;
              }
            ];
          }
          {
            _args = [
              {
                match = {class = "firefox";};
                workspace = 4;
              }
            ];
          }
          {
            _args = [
              {
                match = {class = "zen-beta";};
                workspace = 4;
              }
            ];
          }
          {
            _args = [
              {
                match = {class = "steam";};
                workspace = "5 silent";
              }
            ];
          }
          {
            _args = [
              {
                match = {class = "discord";};
                workspace = "6 silent";
              }
            ];
          }
          {
            _args = [
              {
                match = {class = "firefox";};
                idle_inhibit = "fullscreen";
              }
            ];
          }
          {
            _args = [
              {
                match = {class = "zen";};
                idle_inhibit = "fullscreen";
              }
            ];
          }
        ];
        config = {
          animations.enabled = true;
          input = {
            kb_layout = "us, de";
            kb_options = "grp:win_space_toggle";
            follow_mouse = 1;
            touchpad.natural_scroll = true;
            sensitivity = 0;
          };
          general = {
            gaps_in = 5;
            gaps_out = 20;
            border_size = 2;
            "col.active_border" = lib.generators.mkLuaInline ''
              { colors = { activeBorder, activeBorderGrad }, angle = 45 }
            '';
            "col.inactive_border" = lib.generators.mkLuaInline ''
              { colors = { inactiveBorder } }
            '';
            layout = "dwindle";
            allow_tearing = true;
            resize_on_border = true;
          };
          decoration = {
            rounding = 15;
            active_opacity = 1.0;
            inactive_opacity = 0.96;
            fullscreen_opacity = 1.0;
            shadow = {
              enabled = true;
              color = "0x66000000";
              offset = "5 5";
              scale = 1;
              render_power = 2;
              range = 40;
            };
            blur = {
              enabled = true;
              size = 5;
              new_optimizations = true;
              passes = 2;
              brightness = 1.0;
              contrast = 1.0;
              noise = 0.01;
              vibrancy = 0.2;
              vibrancy_darkness = 0.5;
              popups = true;
              popups_ignorealpha = 0.2;
            };
          };
          dwindle.preserve_split = true;
          gestures = {
            workspace_swipe_invert = false;
            workspace_swipe_forever = true;
            workspace_swipe_cancel_ratio = 0.1;
          };
          misc = {
            force_default_wallpaper = 0;
            disable_hyprland_logo = true;
            disable_splash_rendering = false;
            disable_autoreload = false;
            mouse_move_enables_dpms = true;
            key_press_enables_dpms = true;
            background_color = lib.generators.mkLuaInline "backgroundColor";
            vrr = 2;
          };
          render.direct_scanout = true;
          xwayland.force_zero_scaling = true;
        };

        curve = {
          _args = [
            "myBezier"
            (lib.generators.mkLuaInline "{ type = \"bezier\", points = { {0.3, 0.3}, {0.1, 1.05} } }")
          ];
        };

        animation = [
          {
            _args = [
              {
                leaf = "windows";
                enabled = true;
                speed = 4;
                bezier = "myBezier";
              }
            ];
          }
          {
            _args = [
              {
                leaf = "windowsOut";
                enabled = true;
                speed = 3;
                bezier = "default";
                style = "popin 80%";
              }
            ];
          }
          {
            _args = [
              {
                leaf = "border";
                enabled = true;
                speed = 2;
                bezier = "default";
              }
            ];
          }
          {
            _args = [
              {
                leaf = "borderangle";
                enabled = true;
                speed = 2;
                bezier = "default";
              }
            ];
          }
          {
            _args = [
              {
                leaf = "fade";
                enabled = true;
                speed = 4;
                bezier = "default";
              }
            ];
          }
          {
            _args = [
              {
                leaf = "workspaces";
                enabled = true;
                speed = 2;
                bezier = "default";
                style = "slide";
              }
            ];
          }
        ];
        device = {
          name = "logitech-gaming-mouse-g502-keyboard";
          sensitivity = -0.5;
        };
        bind =
          [
            # Window management
            {_args = ["ALT + space" (lib.generators.mkLuaInline "hl.dsp.window.close()")];}
            {_args = ["${mod} + P" (lib.generators.mkLuaInline "hl.dsp.window.pin()")];}
            {_args = ["${mod} + F" (lib.generators.mkLuaInline "hl.dsp.window.fullscreen()")];}
            {_args = ["${mod} + Q" (lib.generators.mkLuaInline "hl.dsp.window.pseudo()")];}
            {_args = ["CTRL + space" (lib.generators.mkLuaInline "hl.dsp.window.float({ action = \"toggle\" })")];}
            # Enter resize submap
            {_args = ["${mod} + R" (lib.generators.mkLuaInline ''hl.dsp.submap("resize")'')];}
            # Screenshots
            {_args = ["${mod} + P" (exec "grimblast --notify --freeze copysave area")];}
            {_args = ["${mod} + SHIFT + P" (exec "grimblast --notify copysave active")];}
            {_args = ["${mod} + ALT + P" (exec "grimblast --notify copysave screen")];}
            # Apps
            {_args = ["${mod} + Return" (exec "wezterm")];}
            {_args = ["${mod} + E" (exec "wezterm --class='nvim' -e 'nvim'")];}
            {_args = ["${mod} + A" (exec "matshell picker")];}
            {_args = ["${mod} + B" (exec "zen-beta")];}
            {_args = ["${mod} + Y" (exec "pear-desktop")];}
            {_args = ["${mod} + G" (exec "steam")];}
            {_args = ["${mod} + D" (exec "discord")];}
            {_args = ["${mod} + C" (exec "coolercontrol")];}
            {_args = ["${mod} + S" (exec "localsend_app")];}
            {_args = ["${mod} + SHIFT + Q" (exec "matshell logout")];}
            {_args = ["${mod} + SHIFT + W" (exec "matshell wall-rand")];}
            {_args = ["${mod} + SHIFT + V" (exec "virsh --connect qemu:///system start win10")];}
            # Move focus
            {_args = ["${mod} + H" (lib.generators.mkLuaInline ''hl.dsp.focus({ direction = "left" })'')];}
            {_args = ["${mod} + L" (lib.generators.mkLuaInline ''hl.dsp.focus({ direction = "right" })'')];}
            {_args = ["${mod} + K" (lib.generators.mkLuaInline ''hl.dsp.focus({ direction = "up" })'')];}
            {_args = ["${mod} + J" (lib.generators.mkLuaInline ''hl.dsp.focus({ direction = "down" })'')];}
            # Move window
            {_args = ["${mod} + SHIFT + H" (lib.generators.mkLuaInline ''hl.dsp.window.move({ direction = "left" })'')];}
            {_args = ["${mod} + SHIFT + L" (lib.generators.mkLuaInline ''hl.dsp.window.move({ direction = "right" })'')];}
            {_args = ["${mod} + SHIFT + K" (lib.generators.mkLuaInline ''hl.dsp.window.move({ direction = "up" })'')];}
            {_args = ["${mod} + SHIFT + J" (lib.generators.mkLuaInline ''hl.dsp.window.move({ direction = "down" })'')];}
            # Workspace scroll
            {_args = ["${mod} + mouse_down" (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = "e+1" })'')];}
            {_args = ["${mod} + mouse_up" (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = "e-1" })'')];}
            # Next workspace on monitor
            {_args = ["CTRL + ALT + right" (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = "m+1" })'')];}
            {_args = ["CTRL + ALT + left" (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = "m-1" })'')];}
            # Mouse side buttons
            {_args = ["mouse:275" (exec "wl-copy $(wl-paste -p)")];}
            {_args = ["mouse:276" (exec "wtype -M ctrl -M shift v -m ctrl -m shift")];}
            # Mouse drag/resize
            {_args = ["${mod} + mouse:272" (lib.generators.mkLuaInline "hl.dsp.window.drag()") {mouse = true;}];}
            {_args = ["${mod} + mouse:273" (lib.generators.mkLuaInline "hl.dsp.window.resize()") {mouse = true;}];}
            # Audio controls
            {_args = ["XF86AudioRaiseVolume" (exec "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+")];}
            {_args = ["XF86AudioLowerVolume" (exec "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")];}
            {_args = ["XF86AudioMute" (exec "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")];}
            {_args = ["XF86AudioPlay" (exec "playerctl play-pause")];}
            {_args = ["XF86AudioNext" (exec "playerctl next")];}
            {_args = ["XF86AudioPrev" (exec "playerctl previous")];}
            {_args = ["XF86AudioStop" (exec "playerctl stop")];}
          ]
          ++ workspaces;
      };
      extraConfig = ''
        hl.on("hyprland.start", function()
          hl.exec_cmd("hyprctl setcursor ${cursorName} ${toString pointer.size}")
          hl.exec_cmd("sleep 1s && matshell wall-rand")
          hl.exec_cmd("[workspace 1 silent] wezterm")
        end)
      '';
    };
  };
}
