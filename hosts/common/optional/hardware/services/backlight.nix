{
  config,
  lib,
  ...
}: {
  options = {
    hardware.services.backlight.enable = lib.mkEnableOption "Enable brillo backlight control for notebook";
  };

  config = lib.mkIf config.hardware.services.backlight.enable {
    hardware.brillo.enable = true;
    hardware.acpilight.enable = true;
  };
}
