{
  config,
  lib,
  ...
}:
{
  options = {
    coolercontrol.enable = lib.mkEnableOption "enable coolercontrol for cooling device control";
  };

  config = lib.mkIf config.coolercontrol.enable {

    programs.coolercontrol= {
      enable = true;
    };

  };
}
