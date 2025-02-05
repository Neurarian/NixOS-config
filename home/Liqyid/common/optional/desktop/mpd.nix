{
  config,
  lib,
  ...
}: {
  options = {
    desktop.mpd.enable = lib.mkEnableOption "enable mpd";
  };

  config = lib.mkIf config.desktop.mpd.enable {
    services = {
      mpd = {
        enable = true;
      };
      mpd-mpris = {
        enable = true;
        mpd.useLocal = true;
      };
    };
  };
}
