{ pkgs, ... }:
{
  home.packages = with pkgs; [
    hyprpaper
    hyprcursor
    catppuccin-cursors.macchiatoDark
    gnome-control-center
    mission-center
    wlogout
    glib
    libnotify
  ];

  services.mako = {
    enable = true;
    # catppuccin.enable = true;
    sort = "-time";
    layer = "overlay";
    width = 300;
    height = 110;
    borderSize = 2;
    borderRadius = 15;
    icons = true;
    maxIconSize = 64;
    defaultTimeout = 5000;
    ignoreTimeout = true;
    font = "Jetbrains Mono Nerd Font 14";
    extraConfig = ''

      #[urgency=low]
      #border-color=#cccccc

      #[urgency=normal]
      #border-color=#d08770

      [urgency=high]
      border-color=#bf616a
      default-timeout=0

      [category=mpd]
      default-timeout=2000
      group-by=category
    '';
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;

      preload = [ "$HOME/.dotfiles/nix/home/gui/wallpaper" ];

      wallpaper = [
        "eDP-1, $HOME/.dotfiles/nix/home/gui/wallpaper"
      ];
    };
  };

  programs.hyprlock = {
    enable = true;
    settings = {
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
          color = "rgb(202, 211, 245)";
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
          color = "rgb(202, 211, 245)";
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
          color = "rgb(202, 211, 245)";
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
          path = "$HOME/.dotfiles/nix/home/gui/.face";
          size = 350;
          border_color = "rgb(24, 25, 38)";
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
          font_color = "rgb(202, 211, 245)";
          inner_color = "rgb(91, 96, 120)";
          outer_color = "rgb(24, 25, 38)";
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
          timeout = 900;
          on-timeout = "hyprlock";
        }
        {
          timeout = 1200;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

  wayland.windowManager.hyprland = {
    enable = true; # enable Hyprland
    systemd.enable = true;
    # catppuccin.enable = true;
    extraConfig = ''

      # This is an example Hyprland config file.
      #
      # Refer to the wiki for more information.


      # Please note not all available settings / options are set here.

      # For a full list, see the wiki
      exec-once = ags
      exec-once = hyprpaper & ~/scripts/wallpaper_g910.sh
      # See https://wiki.hyprland.org/Configuring/Monitors/

      #monitor=,preferred,auto,auto

      # Window-Rules
      #
      windowrule = workspace 2, youtube-music
      windowrule = workspace 4, firefox
      windowrule = idleinhibit fullscreen, qutebrowser
      windowrule = workspace 5, steam
      #windowrule = nofocus, steam
      windowrule = workspace 6 silent, discord
      #windowrule = workspace 6, 
      #windowrule = workspace 7, vlc
      #windowrule = workspace 8, ranger
      #windowrule = tile, google-chrome-stable

      # See https://wiki.hyprland.org/Configuring/Keywords/ for more
      exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
      # Execute your favorite apps at launch
      exec-once = mako & polkit-agent-helper-1 & systemctl start --user polkit-gnome-authentication-agent-1 & ydotoold
      exec-once = hyprctl setcursor catppuccin-macchiato-dark-cursors 24
      exec-once = wl-paste --watch cliphist store
      exec-once = ~/scripts/updatewal-swww.sh
      exec-once = [workspace 1 silent] kitty -e tmux
      exec-once = [workspace 2 silent] youtube-music
      exec-once = [workspace 4 silent] firefox
      exec-once = [workspace 5 silent] steam
      exec-once = [workspace 6 silent] discord
      exec-once = [workspace 2 silent] kitty -e vis
      #exec-once = [workspace 7 silent] 
      #exec-once = [workspace 8 silent] 
      #exec-once = [workspace 9 silent] 
      #exec-once = [workspace 10 silent] 

      # Source a file (multi-file configs)
      # source = ~/.config/hypr/myColors.:conf
      # source = ~/.cache/wal/colors-hyprland.conf
      # Some default env vars.

      env = XCURSOR_THEME,catppuccin-macchiato-dark-cursors
      env = XCURSOR_SIZE,24
      env = HYPRCURSOR_THEME,catppuccin-macchiato-dark-cursors
      env = HYPRCURSOR_SIZE,24

      # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
      input {
          kb_layout = us, de
          kb_variant =
          kb_model =
          kb_options = grp:win_space_toggle
          kb_rules =

          follow_mouse = 1

          touchpad {
              natural_scroll = true
          }

          sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
      }

      general {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more

          gaps_in = 5
          gaps_out = 20
          border_size = 2
          col.active_border = $accent rgba($accentAlphac1) 45deg
          # col.inactive_border = rgba(595959aa)
          #no_cursor_warps = true

          layout = master

          # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
          allow_tearing = false
      }

      decoration {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more

          rounding = 10

          blur {
              enabled = true
              size = 3
              new_optimizations = true
              passes = 1
          }

          active_opacity = 1.0
          inactive_opacity = 1.0
          fullscreen_opacity = 1.0
          

          drop_shadow = true
          shadow_range = 30
          shadow_render_power = 3
          col.shadow = 0x66000000
      }

      animations {
          enabled = true

          # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

          bezier = myBezier, 0.05, 0.9, 0.1, 1.05

          animation = windows, 1, 7, myBezier
          animation = windowsOut, 1, 7, default, popin 80%
          animation = border, 1, 10, default
          animation = borderangle, 1, 8, default
          animation = fade, 1, 7, default
          animation = workspaces, 1, 6, default
      }

      dwindle {
          # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
          pseudotile = true # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = true # you probably want this
      }

      master {
          # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
      }

      gestures {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          workspace_swipe = on 
          workspace_swipe_invert = no 
          workspace_swipe_cancel_ratio = 0.1
      }

      misc {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          force_default_wallpaper = 0 # Set to 0 to disable the anime mascot wallpapers
          disable_hyprland_logo = true
          disable_splash_rendering = false
          disable_autoreload = false
          mouse_move_enables_dpms = true
          key_press_enables_dpms = true
      }
      # Example per-device config
      # See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
      device {
          name = logitech-gaming-mouse-g502-keyboard
          sensitivity = -0.5
      }

      # Example windowrule v1
      # windowrule = float, ^(kitty)$
      # Example windowrule v2
      # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
      # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more


      # Bindings
      # See https://wiki.hyprland.org/Configuring/Keywords/ for more
      $mainMod = SUPER

      bind = $mainMod, Return, exec, kitty
      bind = ALT, space, killactive,
      bind = CONTROL, Space, togglefloating,
      bind = $mainMod, D, exec, wofi --show run
      bind = $mainMod, Q, pseudo, # dwindle
      bind = ALT, J, togglesplit, # dwindle
      bind = $mainMod, F, fullscreen,
      bind = $mainMod, B, exec, firefox
      bind = $mainMod, Y, exec, youtube-music
      bind = $mainMod, C, exec, coolercontrol
      bind = $mainMod CTRL, Q, exec, wlogout
      bind = $mainMod, S, exec, localsend
      bind = $mainMod, PRINT, exec, ~/scripts/grim.sh
      bind = $mainMod SHIFT, W, exec, ~/scripts/wal.sh && ~/scripts/wallpaper_g910.sh
      bind = $mainMod CTRL, RETURN, exec, ~/scripts/applauncher.sh
      bind = $mainMod CTRL, F, exec, ~/scripts/filemanager.sh
      bind = $mainMod CTRL, C, exec, ~/scripts/cliphist.sh
      bind = $mainMod SHIFT, B, exec, ~/scripts/waybar.sh
      bind = $mainMod SHIFT, V, exec, ~/scripts/windows_vm.sh


      # Move focus
      bind = $mainMod, H, movefocus, l
      bind = $mainMod, L, movefocus, r
      bind = $mainMod, K, movefocus, u
      bind = $mainMod, J, movefocus, d

      bind = $mainMod SHIFT, H, movewindow, l
      bind = $mainMod SHIFT, L, movewindow, r
      bind = $mainMod SHIFT, K, movewindow, u
      bind = $mainMod SHIFT, J, movewindow, d

      # Switch workspaces with mainMod + [0-9]
      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 5, workspace, 5
      bind = $mainMod, 6, workspace, 6
      bind = $mainMod, 7, workspace, 7
      bind = $mainMod, 8, workspace, 8
      bind = $mainMod, 9, workspace, 9
      bind = $mainMod, 0, workspace, 10

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      bind = $mainMod SHIFT, 1, movetoworkspace, 1
      bind = $mainMod SHIFT, 2, movetoworkspace, 2
      bind = $mainMod SHIFT, 3, movetoworkspace, 3
      bind = $mainMod SHIFT, 4, movetoworkspace, 4
      bind = $mainMod SHIFT, 5, movetoworkspace, 5
      bind = $mainMod SHIFT, 6, movetoworkspace, 6
      bind = $mainMod SHIFT, 7, movetoworkspace, 7
      bind = $mainMod SHIFT, 8, movetoworkspace, 8
      bind = $mainMod SHIFT, 9, movetoworkspace, 9
      bind = $mainMod SHIFT, 0, movetoworkspace, 10

      # Scroll through existing workspaces with mainMod + scroll
      bind = $mainMod, mouse_down, workspace, e+1
      bind = $mainMod, mouse_up, workspace, e-1

      # next workspace on monitor
      bind = CONTROL_ALT, right, workspace, m+1
      bind = CONTROL_ALT, left, workspace, m-1

      # lock
      bind = CONTROL_ALT, L, exec, swaylock

      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow

      #bind = SUPER,Print,exec,knip
      bind = Super,Print,exec,~/.local/bin/grim-screenshot
      bind = SHIFT,Print,exec,~/.local/bin/grim-screenshot screen

      bind = ALT, F, exec, ~/lua/wm-keymap.lua f
      bind = ALT, B, exec, ~/lua/wm-keymap.lua b
      bind = ALT, C, exec, clipman pick -t wofi && wtype -M ctrl v -m ctrl
      bind = ALT, M, exec, movies
      bind = ALT,I,exec, /usr/bin/sh ~/PhpStorm/bin/phpstorm.sh & hyprctl dispatch workspace 3
      bind = ALT, T, exec, ~/lua/wm-keymap.lua t
      bind = $mainMod, E, exec, kitty --class="nvim" -e "nvim"
      #bind = $mainMod, S, exec, syncthingtray --webui & hyprctl dispatch workspace 7
      bind = $mainMod, T, exec, kitty --class="task-floating" -t 'taskwarrior' -o window.opacity=1 -e "taskwarrior-tui"
      #bind = $mainMod, P, exec, pull-dotfiles
      #bind = $mainMod, M, exec, ~/.config/hyprland/menu.sh
      # Mod+` ssh connect in the alacritty window
      #bind = $mainMod, Grave, exec, ~/ssh.py 'alacritty -e zsh -c'

      # mouse side buttons
      bind=,mouse:275,exec,wl-copy $(wl-paste -p) # copy selected text
      bind=,mouse:276,exec,wtype -M ctrl -M shift v -m ctrl -m shift # paste by Ctrl+Shift+v

      # resize submap (mode)
      bind=SUPER,R,submap,resize
      submap=resize
      binde=,L,resizeactive,40 0
      binde=,H,resizeactive,-40 0
      binde=,K,resizeactive,0 -40
      binde=,J,resizeactive,0 40
      bind=,escape,submap,reset
      bind=,Return,submap,reset
      submap=reset

      # exit mode
      bind=SUPER,escape,exec,hyprctl dispatch submap logout; notify-send -a Hyprland -t 3500 $'\ne - exit\n\nr - reboot\n\ns - suspend\n\nS - poweroff\n\nl - lock' -i /usr/share/icons/breeze-dark/actions/32/system-suspend.svg
      submap=logout
      bindr =,E,exec,~/.config/hyprland/exit.sh &
      bindr =,S,exec,hyprctl dispatch submap reset && systemctl suspend
      bindr =,R,exec,systemctl reboot
      bindr =SHIFT,S,exec,systemctl poweroff -i
      bindr =,L,exec,hyprctl dispatch submap reset && swaylock
      bindr=,escape,submap,reset
      bind=,Return,submap,reset
      submap=reset

      # vpn mode
      bind=ALT,V,exec,hyprctl dispatch submap vpn; notify-send -t 2500 -c vpn -i /usr/share/icons/breeze-dark/apps/48/alienarena.svg -a 'VPN' $'\n1 - wireguard NL\n\n2 - Openvpn US\n\n0 - Disable VPN'
      submap=vpn
      bind =, 1, exec, hyprctl dispatch submap reset ; ~/lua/vpn.lua 1
      bind =, 2, exec, hyprctl dispatch submap reset ; ~/lua/vpn.lua 2
      bind =, 3, exec, hyprctl dispatch submap reset ; ~/lua/vpn.lua 3
      bind =, 4, exec, hyprctl dispatch submap reset ; ~/lua/vpn.lua 4
      bind =, 5, exec, hyprctl dispatch submap reset ; ~/lua/vpn.lua 5
      bind =, 0, exec, hyprctl dispatch submap reset ; ~/lua/vpn.lua 0
      bind=,escape,submap,reset
      bind=,Return,submap,reset
      submap=reset
    '';
  };
}
