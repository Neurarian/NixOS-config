{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.gaming.enable = lib.mkEnableOption "Enable gaming software";

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
    #services.getty.autologinUser = "Liqyid";
    environment = {
      systemPackages = with pkgs; [
        mangohud
        protonup
      ];
    loginShellInit =  ''
    [[ "$(tty)" = "dev/tty2" ]] && gs.sh 
    '';
    };

  };
}
