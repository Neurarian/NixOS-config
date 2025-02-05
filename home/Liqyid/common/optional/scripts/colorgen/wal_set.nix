{
  pkgs,
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.scripts.wallpaperColorgen.enable {
    scripts.wallpaperColorgen.output.wal_set = pkgs.writeShellApplication {
      name = "wal_set";
      runtimeInputs = with pkgs; [
        hyprpaper
        fd
        ripgrep
      ];
      text = ''
           #!/bin/bash

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

           # unload previous wallpaper

           hyprctl hyprpaper unload all

           # Set the new wallpaper

           apply_hyprpaper

           # Get wallpaper image name & send notification

           newwall=$(basename "$wallpaper_path")
           notify-send "Colors and Wallpaper updated" "with image $newwall"

           colorgen "$wallpaper_path" --apply --smart

           echo "DONE!"

      '';
    };
  };
}
