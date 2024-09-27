{
  config,
  pkgs,
  lib,
  ...
}:
{
  options = {
    overskride.enable = lib.mkEnableOption "enable overskride bluetooth client";
  };

  config = lib.mkIf config.overskride.enable {

    home.packages = with pkgs; [
      overskride
    ];
  };
}
