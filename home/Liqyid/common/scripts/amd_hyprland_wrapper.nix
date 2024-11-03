{ pkgs, inputs, ... }:
let
  hyprwrapperAmd = pkgs.writeShellApplication {
    name = "hyprwrapperAmd";

    runtimeInputs = [ inputs.hyprland.packages.${pkgs.system}.default ];

    text = ''
      #!/bin/bash

      cd ~

      export _JAVA_AWT_WM_NONREPARENTING=1
      export XCURSOR_SIZE=24
      export XDG_CURRENT_DESKTOP=Hyprland
      export XDG_SESSION_DESKTOP=Hyprland
      export QT_AUTO_SCREEN_SCALE_FACTOR=1
      export QT_QPA_PLATFORM="wayland;xcb"
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      export QT_QPA_PLATFORMTHEME=qt5ct
      export SDL_VIDEODRIVER=x11
      export GDK_BACKEND="wayland,x11"

      exec Hyprland
    '';
  };
in
{
  home.packages = [ hyprwrapperAmd ];
}
