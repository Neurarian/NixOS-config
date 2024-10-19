{
  config,
  lib,
  ...
}:
{
  options = {
    desktop.cava.enable = lib.mkEnableOption "enable cava";
  };

  config = lib.mkIf config.desktop.cava.enable {

    programs = {
      cava = {
        enable = true;
        settings = {

          general = {
            framerate = 60;
            bar_width = 4;
            sleeptimer = 30;
          };
          input.method = "pipewire";
          smoothing = {
            noise_reduction = 77;
            montercat = 1;
            waves = 1;
          };
          color = {
            background = "default";
            foreground = "default";
          };
        };

      };
    };

  };
}
