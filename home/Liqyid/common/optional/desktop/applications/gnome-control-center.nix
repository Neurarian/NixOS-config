{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    desktop.applications.gnome-control-center.enable = lib.mkEnableOption "enable gnome-control-center";
  };

  config = lib.mkIf config.desktop.applications.gnome-control-center.enable {
    home.packages = [
      pkgs.gnome-control-center
    ];
  };
}
