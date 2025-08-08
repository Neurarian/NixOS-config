{
  config,
  lib,
  pkgs,
  ...
}: {
  options.gaming.steam.enable = lib.mkEnableOption "Enable steam and related software";

  config = lib.mkIf config.gaming.steam.enable {
    programs = {
      gamescope = {
        enable = true;
        capSysNice = true;
      };
      steam = {
        enable = true;
        gamescopeSession.enable = true;
      };
      gamemode.enable = true;
    };

    environment = {
      systemPackages = [
        pkgs.mangohud
        pkgs.protonup
      ];
      loginShellInit = ''
        [[ "$(tty)" = "dev/tty2" ]] && gs.sh
      '';
    };

    gaming.scripts.gamescope.enable = true;
  };
}
