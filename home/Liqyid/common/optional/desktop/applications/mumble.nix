{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    desktop.applications.mumble.enable = lib.mkEnableOption "enable mumble voice chat";
  };

  config = lib.mkIf config.desktop.applications.mumble.enable {
    home.packages = [
      pkgs.mumble
    ];
  };
}
