{
  config,
  lib,
  ...
}:
{
  options = {
    desktop.fuzzel.enable = lib.mkEnableOption "enable fuzzel";
  };

  config = lib.mkIf config.desktop.fuzzel.enable {

    programs = {
      fuzzel = {
        enable = true;
      };
    };

  };
}
