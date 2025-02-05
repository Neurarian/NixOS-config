{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    desktop.overskride.enable = lib.mkEnableOption "enable overskride bluetooth client";
  };

  config = lib.mkIf config.desktop.overskride.enable {
    home.packages = with pkgs; [
      overskride
    ];
  };
}
