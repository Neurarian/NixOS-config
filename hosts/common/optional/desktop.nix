{
  config,
  lib,
  ...
}: {
  options = {
    desktop.services.enable = lib.mkEnableOption "enable desktop related services";
  };

  config = lib.mkIf config.desktop.services.enable {
    services.gvfs.enable = true;
  };
}
