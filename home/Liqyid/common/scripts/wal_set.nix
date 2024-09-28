{pkgs, ...}:
  let
    wal_set = pkgs.writeShellScriptBin
      "wal_set"
      ''
      
#!/bin/zsh

# Load wal wallpaper

hyprctl hyprpaper unload all

# Load current pywal color scheme

source "$HOME/.cache/wal/colors.sh"

# Copy wal selected wallpaper into .cache folder (rofi)

cp $(cat $HOME/.cache/wal/wal) $HOME/.cache/current_wallpaper.jpg
# echo "* { current-image: url(\"$HOME/.cache/current_wallpaper.jpg\", height); }" > "$HOME/.cache/current_wallpaper.rasi"

# Set the new wallpaper

hyprctl hyprpaper preload $(cat $HOME/.cache/wal/wal) && hyprctl hyprpaper wallpaper "eDP-1, $(cat $HOME/.cache/wal/wal)"

# Update music visualizer colors & mako theme

hyprctl dispatch focuswindow kitty
ydotool key 19:1 19:0
#~/.config/mako/update-theme.sh

# Get wallpaper image name & send notification

newwall=$(< $HOME/.cache/wal/wal sed "s|$HOME/Pictures/wallpaper/||g")
notify-send "Colors and Wallpaper updated" "with image $newwall"

echo "DONE!"

$HOME/.config/ags/scripts/colorgen.sh "$HOME/.cache/current_wallpaper.jpg" --apply --smart
	    '';
  in {
    home.packages = [ wal_set ];
} 

