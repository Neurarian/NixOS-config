{pkgs, inputs, ...}:
  let
    hyprwrapperNvidia = pkgs.writeShellApplication {
      name = "hyprwrapperNvidia";

      runtimeInputs = [ inputs.hyprland.packages.${pkgs.system}.default ];

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
    home.packages = [ hyprwrapperNvidia ];
} 

