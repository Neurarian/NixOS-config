{
  config,
  lib,
  inputs,
  system,
  ...
}: {
  options = {
    desktop.zen-browser.applications.enable = lib.mkEnableOption "enable zen browser";
  };

  config = lib.mkIf config.desktop.zen-browser.applications.enable {
    home.packages = [
      inputs.zen-browser.packages.${system}.default
    ];
  };
}
