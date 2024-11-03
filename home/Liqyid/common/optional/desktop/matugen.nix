
{
  inputs,
  config,
  lib,
  system,
  ...
}:
{
  imports = [
    inputs.matugen.nixosModules.matugen
  ];
  options = {
    desktop.matugen.enable = lib.mkEnableOption "enable matugen colorgen";
  };

  config = lib.mkIf config.desktop.matugen.enable {
    home.packages = [
    inputs.matugen.packages.${system}.default
    ];

  };
}
