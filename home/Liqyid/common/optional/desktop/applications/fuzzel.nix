{
  config,
  lib,
  ...
}: {
  options = {
    desktop.applications.fuzzel.enable = lib.mkEnableOption "enable fuzzel";
  };

  config = lib.mkIf config.desktop.applications.fuzzel.enable {
    programs = {
      fuzzel = {
        enable = true;
      };
    };
  };
}
