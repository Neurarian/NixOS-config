{ pkgs, ... }:
let
  wal_set = pkgs.writeShellApplication {
  name = "wal_set";
  runtimeInputs = with pkgs; [ wlr-randr ];
  text = ''
    #!/bin/bash

    apply_hyprpaper() {
      local wallpaper_path
      wallpaper_path="$(< "$HOME/.cache/wal/wal")"

      # Preload the wallpaper once, since it doesn't change per monitor
      hyprctl hyprpaper preload "$wallpaper_path"

      # Set wallpaper for each monitor
      wlr-randr | awk '/^[^ ]/ {print $1}' | while read -r monitor; do
	hyprctl hyprpaper wallpaper "$monitor, $wallpaper_path"
      done
    }

    # unload previous wallpaper

    hyprctl hyprpaper unload all

    # Copy wal selected wallpaper into .cache folder

    cp "$(< "$HOME/.cache/wal/wal")" "$HOME/.cache/current_wallpaper.jpg"

    # Set the new wallpaper

    apply_hyprpaper

    # Get wallpaper image name & send notification

    newwall=$(basename "$(< "$HOME/.cache/wal/wal")")
    notify-send "Colors and Wallpaper updated" "with image $newwall"

    "$HOME"/.config/ags/scripts/colorgen.sh "$HOME/.cache/current_wallpaper.jpg" --apply --smart

    echo "DONE!"

    	    '';
  };
in
{
  home.packages = [ wal_set ];
}
