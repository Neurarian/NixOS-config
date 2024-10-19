{
  config,
  pkgs,
  lib,
  ...
}:
{
  options = {
    desktop.ytmusic.enable = lib.mkEnableOption "enable youtube music client";
  };

  config = lib.mkIf config.desktop.ytmusic.enable {

    home.packages = with pkgs; [
      youtube-music
    ];
  };
}
