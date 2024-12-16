{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    desktop.cad.enable = lib.mkEnableOption "enable software required for CAD & 3D printing";
  };

  config = lib.mkIf config.desktop.cad.enable {

    home.packages = with pkgs; [
      freecad-wayland
      prusa-slicer
    ];

    programs = {
      fuzzel = {
        enable = true;
      };
    };

  };
}
