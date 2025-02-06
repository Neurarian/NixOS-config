{
  config,
  lib,
  pkgs,
  ...
}: {
  options.gaming.enable = lib.mkEnableOption "Enable steam and related software";

  config = lib.mkIf config.gaming.enable {
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
      systemPackages = with pkgs; [
        mangohud
        protonup
      ];
      loginShellInit = ''
        [[ "$(tty)" = "dev/tty2" ]] && gs.sh
      '';
    };

    scripts.gamescope.enable = true;
  };
}
