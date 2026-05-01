{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    desktop.applications.oversteer.enable = lib.mkEnableOption "enable oversteer ffb control";
  };

  config = lib.mkIf config.desktop.applications.oversteer.enable {
    home.packages = [
      pkgs.oversteer
    ];
  };
}
