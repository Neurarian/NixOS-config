{ pkgs, ... }:
let
  wal_init = pkgs.writeShellApplication {
    name = "wal_init";

    runtimeInputs = with pkgs; [ pywal ];

    text = ''
      #!/bin/bash
      if [ ! -d ~/Pictures/wallpapers/ ]; then
	
      wal -q  -i ${builtins.toString ./../optional/hyprland/default_wallpaper}

      else

      wal -q  -i ~/Pictures/wallpapers/

      fi
    '';
  };
in
{
  home.packages = [ wal_init ];
}
