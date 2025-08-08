{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    desktop.development.arduino.enable = lib.mkEnableOption "enable arduino IDE";
  };

  config = lib.mkIf config.desktop.development.arduino.enable {
    home.packages = [
      pkgs.arduino-cli
    ];
  };
}
