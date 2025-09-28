{
  inputs,
  lib,
  config,
  ...
}: {
  imports = [
    inputs.matshell.homeManagerModules.default
  ];

  options = {
    desktop.applications.ags.enable = lib.mkEnableOption "enable aylurs gtk shell";
  };

  config = lib.mkIf config.desktop.applications.ags.enable {
    programs.matshell = {
      enable = true;
      autostart = true;
      matugenConfig = true;
    };
  };
}
