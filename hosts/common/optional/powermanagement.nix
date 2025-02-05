{
  lib,
  config,
  ...
}: {
  options = {
    powermanagement.enable = lib.mkEnableOption "Enable notebook powermanagement module";
  };

  config = lib.mkIf config.powermanagement.enable {
    powerManagement = {
      enable = true;
      powertop.enable = true;
    };

    services = {
      power-profiles-daemon.enable = true;
      upower.enable = true;
    };
    backlight.enable = true;
  };
}
