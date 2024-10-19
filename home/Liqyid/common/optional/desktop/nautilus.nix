{
  config,
  pkgs,
  lib,
  ...
}:
{
  options = {
    desktop.nautilus.enable = lib.mkEnableOption "enable nautilus file manager";
  };

  config = lib.mkIf config.desktop.nautilus.enable {

    home.packages = with pkgs; [
      gnome.nautilus
    ];
  };
}
