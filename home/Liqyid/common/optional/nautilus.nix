{
  config,
  pkgs,
  lib,
  ...
}:
{
  options = {
    nautilus.enable = lib.mkEnableOption "enable nautilus file manager";
  };

  config = lib.mkIf config.nautilus.enable {

    home.packages = with pkgs; [
      gnome.nautilus
    ];
  };
}
