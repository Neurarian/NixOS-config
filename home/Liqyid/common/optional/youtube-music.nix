{
  config,
  pkgs,
  lib,
  ...
}:
{
  options = {
    ytmusic.enable = lib.mkEnableOption "enable youtube music client";
  };

  config = lib.mkIf config.ytmusic.enable {

    home.packages = with pkgs; [
      youtube-music
    ];
  };
}
