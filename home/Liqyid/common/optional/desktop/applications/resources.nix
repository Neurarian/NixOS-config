{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    desktop.applications.resources.enable = lib.mkEnableOption "enable resources system resources manager";
  };

  config = lib.mkIf config.desktop.applications.resources.enable {
    home.packages = [
      pkgs.resources
    ];
  };
}
