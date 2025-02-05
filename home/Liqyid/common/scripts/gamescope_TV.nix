{ pkgs, ... }:
let
  gs_tv.sh = pkgs.writeShellScriptBin "gs_tv.sh" ''
    #!/usr/bin/env bash
    set -xeuo pipefail

    gamescopeArgs=(
        -O HDMI-A-1
        --rt
        -w 1920
        -h 1080
        -r 60
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
in
{
  home.packages = [ gs_tv.sh ];
}
