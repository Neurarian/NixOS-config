{ pkgs, ... }:
let
  wal_init = pkgs.writeShellApplication {
    name = "wal_init";

    runtimeInputs = with pkgs; [ pywal ];

    text = ''
      	    #!/bin/bash
      wal -q  -i ~/Pictures/wallpaper/

      exit
    '';
  };
in
{
  home.packages = [ wal_init ];
}
