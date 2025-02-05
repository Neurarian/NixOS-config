{
  pkgs,
  lib,
  config,
  ...
}: let
  gs.sh = pkgs.writeShellScriptBin "gs.sh" ''
    #!/usr/bin/env bash
    set -xeuo pipefail

    gamescopeArgs=(
        --adaptive-sync # VRR support
        --hdr-enabled
        -O DP-1
        --rt
        -w 3440
        -h 1440
        -r 100
        -f
        --steam
    )
    steamArgs=(
        -pipewire-dmabuf
        -tenfoot
        -steamos3
    )
    mangoConfig=(
        cpu_temp
        gpu_temp
        ram
        vram
    )
    mangoVars=(
        MANGOHUD=0
        MANGOHUD_CONFIG="''$(IFS=,; echo "''${mangoConfig[*]}")"
    )

    export "''${mangoVars[@]}"
    exec gamescope "''${gamescopeArgs[@]}" -- steam "''${steamArgs[@]}"
  '';
in {
  options = {
    scripts.gamescopewm.enable = lib.mkEnableOption "enable steam gamescope wm wrapper script";
  };

  config = lib.mkIf config.scripts.gamescopewm.enable {
    environment.systemPackages = [gs.sh];
  };
}
