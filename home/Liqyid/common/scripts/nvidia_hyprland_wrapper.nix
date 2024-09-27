{pkgs, ...}:
  let
    hyprwrapper = pkgs.writeShellApplication {
      name = "hyprwrapper";

      runtimeInputs = with pkgs; [ hyprland ];

      text = ''
	    #!/bin/bash

	    cd ~
	    export LIBVA_DRIVER_NAME=nvidia
	    export XDG_SESSION_TYPE=wayland
	    export GBM_BACKEND=nvidia-drm
	    export __GLX_VENDOR_LIBRARY_NAME=nvidia
	    export WLR_NO_HARDWARE_CURSORS=1
	    export _JAVA_AWT_WM_NONREPARENTING=1
	    export XCURSOR_SIZE=24

	    exec Hyprland
      '';
   };
  in {
    home.packages = [ hyprwrapper ];
} 

