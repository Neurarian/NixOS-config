{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
{
  options = {
    desktop.hypr.hyprland.enable = lib.mkEnableOption "enable hyprland";
  };

  config = lib.mkIf config.desktop.hypr.hyprland.enable {


    home.packages = with pkgs; [
      hyprcursor
      catppuccin-cursors.macchiatoDark
      wlogout
      glib
      libnotify
    ];

    wayland.windowManager.hyprland =
      let
        pointer = config.home.pointerCursor;
        cursorName = "catppuccin-macchiato-dark-cursors";
      in
      {
        enable = true; # enable Hyprland
        package = inputs.hyprland.packages.${pkgs.system}.default;
        plugins = [
          inputs.Hyprspace.packages.${pkgs.system}.Hyprspace
        ];
        systemd.enable = true;
        settings = {
          source = "~/.config/hypr/hyprland_colors.conf";
          windowrulev2 = [
            "bordercolor $pinnedWindow $pinnedWindowGrad 45deg,pinned:1"
            "workspace 2, class:YouTube Music"
            "workspace 2, initialTitle:wezterm"
            "workspace 4, class:firefox"
            "workspace 4, class:zen"
            "workspace 5 silent, class:steam"
            "workspace 6 silent, class:discord"
            "idleinhibit fullscreen, class:firefox"
            "idleinhibit fullscreen, class:zen"
          ];
          env = [
            "HYPRCURSOR_THEME,${cursorName}"
            "HYPRCURSOR_SIZE,${toString pointer.size}"
          ];
          exec-once = [
            # set cursor for HL itself
            "hyprctl setcursor ${cursorName} ${toString pointer.size}"
            "wl-paste --watch cliphist store"
            "[workspace 1 silent] wezterm "
            "sleep 1s && wal_set"
            ""
          ];
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
            "col.active_border" = "$activeBorder $activeBorderGrad 45deg";
            "col.inactive_border" = "$inactiveBorder";
            layout = "dwindle";
            allow_tearing = true;
            resize_on_border = true;
          };
          decoration = {
            rounding = 15;
            active_opacity = 1.0;
            inactive_opacity = 0.96;
            fullscreen_opacity = 1.0;
            drop_shadow = true;
            shadow_range = 40;
            shadow_render_power = 2;
            "col.shadow" = "0x66000000";
            shadow_offset = "5 5";
            shadow_scale = 1;
            blur = {
              enabled = true;
              size = 10;
              new_optimizations = true;
              passes = 2;
              brightness = 1.0;
              contrast = 1.0;
              noise = 0.1;
              vibrancy = 0.2;
              vibrancy_darkness = 0.5;
              popups = true;
              popups_ignorealpha = 0.2;
            };
          };
          animations = {
            enabled = true;
            bezier = "myBezier, 0.3, 0.3, 0.1, 1.05";
            animation = [
              "windows, 1, 4, myBezier"
              "windowsOut, 1, 3, default, popin 80%"
              "border, 1, 2, default"
              "borderangle, 1, 2, default"
              "fade, 1, 4, default"
              "workspaces, 1, 2, default, slide"
            ];
          };
          dwindle = {
            pseudotile = true;
            preserve_split = true;
          };
          gestures = {
            workspace_swipe = true;
            workspace_swipe_invert = false;
            workspace_swipe_forever = true;
            workspace_swipe_cancel_ratio = 0.1;
          };
          misc = {
            force_default_wallpaper = 0;
            disable_hyprland_logo = true;
            disable_splash_rendering = false;
            disable_autoreload = true;
            mouse_move_enables_dpms = true;
            key_press_enables_dpms = true;
            background_color = "$backgroundColor";
            # will cause screen flicker if = 1
            vrr = 2;
          };
          device = {
            name = "logitech-gaming-mouse-g502-keyboard";
            sensitivity = -0.5;
          };
          xwayland.force_zero_scaling = true;
          render.direct_scanout = true;
          plugin = {
            overview = {
              workspaceActiveBorder = "$activeBorder";
              workspaceInactiveBorder = "$inactiveBorder";
              workspaceBorderSize = 2;
            };
            hyprexpo = {
              columns = 1;
              gap_size = 2;
              bg_col = "rgb(111111)";
              workspace_method = "center current"; # [center/first] [workspace] e.g. first 1 or center m+1

              enable_gesture = true; # laptop touchpad
              gesture_fingers = 3; # 3 or 4
              gesture_distance = 300; # how far is the "max"
              gesture_positive = true; # positive = swipe down. Negative = swipe up.
            };
          };
          "$mod" = "SUPER";
          # Binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
          bind =
            let
              workspaces = builtins.concatLists (
                builtins.genList (
                  x:
                  let
                    wsKey =
                      let
                        # Integer division: c = 0 for x+1 = 1 to 9; c = 1 for x+1 = 10
                        c = (x + 1) / 10;
                      in
                      # 1-9 for ws 1-9 & 0 for ws 10
                      builtins.toString (x + 1 - (c * 10));
                    ws = builtins.toString (x + 1);
                  in
                  [
                    "$mod, ${wsKey}, workspace, ${ws}"
                    "$mod SHIFT, ${wsKey}, movetoworkspace, ${ws}"
                  ]
                ) 10
              );
            in
            [
              # Hyprland
              "ALT, space, killactive"
              "$mod, P, pin"
              "CONTROL, Space, togglefloating,"
              "ALT, J, togglesplit, # dwindle"

              # Software & utils
              "$mod, Return, exec, wezterm"
              "$mod, E, exec, wezterm --class='nvim' -e 'nvim'"
              "$mod, A, exec, fuzzel"
              "$mod, Q, pseudo, # dwindle"
              "$mod, F, fullscreen"
              "$mod, B, exec, zen"
              "$mod, Y, exec, youtube-music && wezterm -e cava"
              "$mod, G, exec, steam"
              "$mod, D, exec, discord"
              "$mod, C, exec, coolercontrol"
              "$mod, S, exec, localsend_app"
              "$mod SHIFT, Q, exec, wlogout"
              "$mod, PRINT, exec, ~/scripts/grim.sh"
              "$mod SHIFT, W, exec, wal_set"
              "$mod SHIFT, V, exec, virsh --connect qemu:///system start win10"

              # Move focus
              "$mod, H, movefocus, l"
              "$mod, L, movefocus, r"
              "$mod, K, movefocus, u"
              "$mod, J, movefocus, d"

              # Move window
              "$mod SHIFT, H, movewindow, l"
              "$mod SHIFT, L, movewindow, r"
              "$mod SHIFT, K, movewindow, u"
              "$mod SHIFT, J, movewindow, d"
              # Scroll through existing workspaces with mainMod + scroll
              "$mod, mouse_down, workspace, e+1"
              "$mod, mouse_up, workspace, e-1"

              # Next workspace on monitor
              "CONTROL_ALT, right, workspace, m+1"
              "CONTROL_ALT, left, workspace, m-1"

              # Plugins
              "$mod, W, overview:toggle"

              # Mouse side buttons
              ",mouse:275,exec,wl-copy $(wl-paste -p)" # copy selected t
              ",mouse:276,exec,wtype -M ctrl -M shift v -m ctrl -m shift" # paste by Ctrl+Shift+v

            ]
            ++ workspaces;
          bindm = [
            # Move/resize windows with mainMod + LMB/RMB and dragging
            "$mod, mouse:272, movewindow"
            "$mod, mouse:273, resizewindow"
          ];
        };

        # Submaps require specific order in config
        extraConfig = ''
          # Resize mode
          bind=SUPER,R,submap,resize
          submap=resize
          binde=,L,resizeactive,40 0
          binde=,H,resizeactive,-40 0
          binde=,K,resizeactive,0 -40
          binde=,J,resizeactive,0 40
          bind=,escape,submap,reset
          bind=,Return,submap,reset
          submap=reset
        '';
      };

  };
}
