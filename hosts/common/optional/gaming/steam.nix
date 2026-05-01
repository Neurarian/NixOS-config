{
  config,
  lib,
  pkgs,
  ...
}: {
  options.gaming.steam = {
    enable = lib.mkEnableOption "Enable Steam and related software";
    ckan.enable = lib.mkEnableOption "Enable CKAN mod manager for KSP";
  };
  config = lib.mkIf config.gaming.steam.enable {
    programs = {
      gamescope = {
        enable = true;
        capSysNice = true;
      };
      steam = {
        enable = true;
        protontricks.enable = true;
        gamescopeSession.enable = true;
      };
      gamemode.enable = true;
    };

    environment = {
      systemPackages =
        [
          pkgs.mangohud
          pkgs.protonup-ng
          pkgs.wine-wayland
          pkgs.winetricks
        ]
        ++ lib.optionals config.gaming.steam.ckan.enable [ pkgs.ckan
        ];
      loginShellInit = ''
        [[ "$(tty)" = "dev/tty2" ]] && gs.sh
      '';
    };

    gaming.scripts.gamescope.enable = true;
  };
}
