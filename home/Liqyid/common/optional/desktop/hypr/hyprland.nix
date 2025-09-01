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
      inputs.ags.packages.${system}.default
      pkgs.wl-clipboard
      pkgs.cliphist
      pkgs.hyprcursor
      pkgs.grimblast
      pkgs.catppuccin-cursors.macchiatoDark
      pkgs.glib
      pkgs.libnotify
    ];

    wayland.windowManager.hyprland = let
      pointer = config.home.pointerCursor;
      cursorName = "catppuccin-macchiato-dark-cursors";
    in {
      enable = true; # enable Hyprland
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      systemd.enable = true;
      settings = {
        source = "hyprland_colors.conf";
        windowrule = [
          "bordercolor $pinnedWindow $pinnedWindowGrad 45deg,pinned:1"
          "workspace 2, class:com.github.th_ch.youtube_music"
          "workspace 4, class:firefox"
          "workspace 4, class:zen-beta"
          "workspace 5 silent, class:steam"
          "workspace 6 silent, class:discord"
          "idleinhibit fullscreen, class:firefox"
          "idleinhibit fullscreen, class:zen"
        ];
        layerrule = [
          "blur, bar"
          "blur, gtk4-layer-shell"
          "xray 1, bar" # Required for the matshell corners style to be blurred homogeneously
          "ignorealpha 0.2, bar"
          "ignorealpha 0.2, gtk4-layer-shell"
        ];
        env = [
          "HYPRCURSOR_THEME,${cursorName}"
          "XCURSOR_THEME,${cursorName}"
          "HYPRCURSOR_SIZE,${toString pointer.size}"
          "XCURSOR_SIZE,${toString pointer.size}"
        ];
        exec-once = [
          # set cursor for HL itself
          "hyprctl setcursor ${cursorName} ${toString pointer.size}"
          "wl-paste --watch cliphist store"
          "sleep 1s && wal_set"
          "[workspace 1 silent] wezterm"
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
          workspace_swipe_invert = false;
          workspace_swipe_forever = true;
          workspace_swipe_cancel_ratio = 0.1;
        };
        /*
           debug = {
        disable_logs = false;
        };
        */
        misc = {
          force_default_wallpaper = 0;
          disable_hyprland_logo = true;
          disable_splash_rendering = false;
          disable_autoreload = false;
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
        "$mod" = "SUPER";
        # Binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
        bind = let
          workspaces = builtins.concatLists (
            builtins.genList (
              x: let
                wsKey = let
                  # Integer division: c = 0 for x+1 = 1 to 9; c = 1 for x+1 = 10
                  c = (x + 1) / 10;
                in
                  # 1-9 for ws 1-9 & 0 for ws 10
                  builtins.toString (x + 1 - (c * 10));
                ws = builtins.toString (x + 1);
              in [
                "$mod, ${wsKey}, workspace, ${ws}"
                "$mod SHIFT, ${wsKey}, movetoworkspace, ${ws}"
              ]
            )
            10
          );
        in
          [
            # Hyprland
            "ALT, space, killactive"
            "$mod, P, pin"
            "$mod, F, fullscreen"
            "$mod, Q, pseudo, # dwindle"
            "CONTROL, Space, togglefloating,"
            "ALT, J, togglesplit, # dwindle"

            # Software & utils
            "$mod, Return, exec, wezterm"
            "$mod, E, exec, wezterm --class='nvim' -e 'nvim'"
            "$mod, A, exec, ags toggle launcher --instance 'matshell'"
            # "mod, X, exec, cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"
            "$mod, B, exec, zen"
            "$mod, Y, exec, youtube-music"
            "$mod, G, exec, steam"
            "$mod, D, exec, discord"
            "$mod, C, exec, coolercontrol"
            "$mod, S, exec, localsend_app"
            "$mod SHIFT, Q, exec, ags toggle logout-menu --instance 'matshell'"
            "$mod SHIFT, W, exec, wal_set"
            "$mod SHIFT, V, exec, virsh --connect qemu:///system start win10"
            "$mod, P, exec, grimblast --notify --freeze copysave area"
            "$mod SHIFT, P, exec, grimblast --notify copysave active"
            "$mod ALT, P, exec, grimblast --notify copysave screen"

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

            # Mouse side buttons
            ",mouse:275,exec,wl-copy $(wl-paste -p)" # copy selected text
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
