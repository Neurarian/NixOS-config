{
  pkgs,
  lib,
  config,
  ...
}: let
  mkGamescope = {
    name,
    output,
    width,
    height,
    refreshRate,
    adaptiveSync ? false,
  }:
    pkgs.writeShellScriptBin name ''
      #!/usr/bin/env bash
      set -xeuo pipefail

      gamescopeArgs=(
          -O ${output}
          --rt
          -w ${toString width}
          -h ${toString height}
          -r ${toString refreshRate}
          -f
          --steam
          ${lib.optionalString adaptiveSync "--adaptive-sync"}
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

  gamescopeScripts = {
    ultrawide = mkGamescope {
      name = "gs.sh";
      output = "DP-1";
      width = 3440;
      height = 1440;
      refreshRate = 100;
      adaptiveSync = true;
    };
    tv = mkGamescope {
      name = "gs_tv.sh";
      output = "HDMI-A-1";
      width = 1920;
      height = 1080;
      refreshRate = 60;
    };
  };
in {
  options.gaming.scripts.gamescope.enable = lib.mkEnableOption "enable steam gamescope wrapper scripts";

  config = lib.mkIf config.gaming.scripts.gamescope.enable {
    environment.systemPackages = builtins.attrValues gamescopeScripts;
  };
}
