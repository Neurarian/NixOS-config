{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    desktop.applications.zotero.enable = lib.mkEnableOption "enable zotero citation manager";
  };

  config = lib.mkIf config.desktop.applications.zotero.enable {
    home.packages = [
      pkgs.zotero
    ];
  };
}
