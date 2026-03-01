{
  pkgs,
  inputs,
  config,
  system,
  lib,
  ...
}: let
  cfg = config.scripts.hyprlandWrapper;
in {
  config =
    lib.mkIf
    (cfg.enable && cfg.gpuType == "amd")
    {
      scripts.hyprlandWrapper.output.hyprwrapperAmd = pkgs.writeShellApplication {
        name = "hyprwrapperAmd";

        runtimeInputs = [inputs.hyprland.packages.${system}.default];

        text = ''
          #!/bin/bash

          cd ~

          export WLR_NO_HARDWARE_CURSORS=1
          export XCURSOR_SIZE=24
          export QT_AUTO_SCREEN_SCALE_FACTOR=1
          export QT_QPA_PLATFORM="wayland;xcb"
          export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
          export QT_QPA_PLATFORMTHEME=qt5ct
          export GDK_BACKEND="wayland,x11"

          exec start-hyprland 
        '';
      };
    };
}
