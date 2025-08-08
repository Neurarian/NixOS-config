{
  lib,
  config,
  ...
}: {
  options = {
    hardware.services.powermanagement.enable = lib.mkEnableOption "Enable notebook powermanagement module";
  };

  config = lib.mkIf config.hardware.services.powermanagement.enable {
    powerManagement = {
      enable = true;
      powertop.enable = true;
    };

    services = {
      power-profiles-daemon.enable = true;
      upower.enable = true;
    };
    hardware.services.backlight.enable = true;
  };
}
