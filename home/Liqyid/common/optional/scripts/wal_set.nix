{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: {
  options = {
    scripts.wallpaperSetter = {
      enable = lib.mkEnableOption "enable script to set wallpaper";
      output = lib.mkOption {
        type = lib.types.attrsOf lib.types.package;
        default = {};
        description = "Attribute set of all scripts required for desktop colorgeneration and setting wallpaper";
      };
    };
  };

  config = lib.mkIf config.scripts.wallpaperSetter.enable {
    scripts.wallpaperSetter.output.wal_set = pkgs.writeShellApplication {
      name = "wal_set";
      runtimeInputs = with pkgs; [
        hyprpaper
        fd
        ripgrep
        vips
        inputs.matugen.packages.${pkgs.system}.default
        image-hct
      ];
      text = ''
        #!/bin/bash
        set -euo pipefail

        if [ ! -d ~/Pictures/wallpapers/ ]; then
          wallpaper_path=${builtins.toString ./../optional/desktop/hypr/default_wallpaper}
        else
          wallpaper_path="$(fd . "$HOME/Pictures/wallpapers" -t f | shuf -n 1)"
        fi

        apply_hyprpaper() {

          # Preload the wallpaper once, since it doesn't change per monitor
          hyprctl hyprpaper preload "$wallpaper_path"

          # Set wallpaper for each monitor
          hyprctl monitors | rg 'Monitor' | awk '{print $2}' | while read -r monitor; do
          hyprctl hyprpaper wallpaper "$monitor, $wallpaper_path"
          done
        }

        if [ "$(image-hct "$wallpaper_path" tone)" -gt 60 ]; then
          mode="light"
        else
          mode="dark"
        fi

        if [ "$(image-hct "$wallpaper_path" chroma)" -lt 20 ]; then
          scheme="scheme-neutral"
        else
          scheme="scheme-vibrant"
        fi

        # Set Material colortheme

        matugen -t "$scheme" -m "$mode" image "$wallpaper_path"

        # unload previous wallpaper

        hyprctl hyprpaper unload all

        # Set the new wallpaper

        apply_hyprpaper

        # Get wallpaper image name & send notification

        newwall=$(basename "$wallpaper_path")
        notify-send "Colors and Wallpaper updated" "with image $newwall"


        echo "DONE!"

      '';
    };
    home.packages = builtins.attrValues config.scripts.wallpaperSetter.output;
  };
}
