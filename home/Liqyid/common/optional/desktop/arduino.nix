{
  config,
  pkgs,
  lib,
  ...
}:
{
  options = {
    desktop.arduino.enable = lib.mkEnableOption "enable arduino IDE";
  };

  config = lib.mkIf config.desktop.arduino.enable {

    home.packages = with pkgs; [
      arduino-cli
    ];
  };
}
