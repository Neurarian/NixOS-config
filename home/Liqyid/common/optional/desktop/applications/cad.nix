{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    desktop.applications.cad.enable = lib.mkEnableOption "enable software required for CAD & 3D printing";
  };

  config = lib.mkIf config.desktop.applications.cad.enable {
    home.packages = [
      pkgs.freecad-wayland
      pkgs.prusa-slicer
    ];

    programs = {
      fuzzel = {
        enable = true;
      };
    };
  };
}
