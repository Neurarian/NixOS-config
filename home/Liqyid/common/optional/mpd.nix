{
  config,
  lib,
  ...
}: {
  options = {
    mpd.enable = lib.mkEnableOption "enable mpd";
  };

  config = lib.mkIf config.mpd.enable {
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
