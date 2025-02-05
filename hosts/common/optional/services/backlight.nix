{
  config,
  lib,
  ...
}: {
  options = {
    backlight.enable = lib.mkEnableOption "Enable brillo backlight control for notebook";
  };

  config = lib.mkIf config.backlight.enable {
    hardware.brillo.enable = true;
    programs.light.enable = true;
  };
}
