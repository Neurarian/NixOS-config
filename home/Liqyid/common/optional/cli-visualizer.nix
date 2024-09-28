{
  config,
  pkgs,
  lib,
  ...
}:
{
  options = {
    clivis.enable = lib.mkEnableOption "enable cli-visualizer";
  };

  config = lib.mkIf config.clivis.enable {

    home.packages = with pkgs; [
      cli-visualizer
    ];
  };
}
