{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    desktop.applications.overskride.enable = lib.mkEnableOption "enable overskride bluetooth client";
  };

  config = lib.mkIf config.desktop.applications.overskride.enable {
    home.packages = with pkgs; [
      overskride
    ];
  };
}
