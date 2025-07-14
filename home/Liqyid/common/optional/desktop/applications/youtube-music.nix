{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    desktop.applications.ytmusic.enable = lib.mkEnableOption "enable youtube music client";
  };

  config = lib.mkIf config.desktop.applications.ytmusic.enable {
    home.packages = with pkgs; [
      youtube-music
    ];
  };
}
