{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    desktop.applications.nautilus.enable = lib.mkEnableOption "enable nautilus file manager";
  };

  config = lib.mkIf config.desktop.applicaitons.nautilus.enable {
    home.packages = with pkgs; [
      nautilus
    ];
  };
}
