{
  inputs,
  lib,
  config,
  ...
}: let
in {
  imports = [
    inputs.matshell.homeManagerModules.default
  ];

  options = {
    desktop.ags.enable = lib.mkEnableOption "enable aylurs gtk shell";
  };

  config = lib.mkIf config.desktop.ags.enable {
    programs.ags = {
      matshell.enable = true;
    };
  };
}
