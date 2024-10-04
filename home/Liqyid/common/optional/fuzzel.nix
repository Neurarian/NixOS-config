
{
  config,
  lib,
  ...
}:
{
  options = {
    fuzzel.enable = lib.mkEnableOption "enable fuzzel";
  };

  config = lib.mkIf config.fuzzel.enable {

    programs = {
      fuzzel = {
        enable = true;
      };
    };

  };
}
