{
  config,
  lib,
  ...
}: {
  options = {
    hardware.services.coolercontrol.enable = lib.mkEnableOption "enable coolercontrol for cooling device control";
  };

  config = lib.mkIf config.hardware.services.coolercontrol.enable {
    programs.coolercontrol = {
      enable = true;
    };
  };
}
