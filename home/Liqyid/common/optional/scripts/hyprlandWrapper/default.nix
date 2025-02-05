{
  lib,
  config,
  ...
}: {
  options = {
    scripts.hyprlandWrapper = {
      enable = lib.mkEnableOption "enable GPU manufacuter-specific Hyprland wrappers";
      gpuType = lib.mkOption {
        type = lib.types.enum ["none" "nvidia" "amd"];
        default = "none";
        description = "Select GPU manufacturer";
      };
      output = lib.mkOption {
        type = lib.types.attrsOf lib.types.package;
        default = {};
        description = "Attribute set of GPU manufacturer-specific Hyprland wrapper scripts";
      };
    };
  };

  config = lib.mkIf config.scripts.hyprlandWrapper.enable {
    home.packages = builtins.attrValues config.scripts.hyprlandWrapper.output;
  };
  imports = [
    ./nvidia_hyprland_wrapper.nix
    ./amd_hyprland_wrapper.nix
  ];
}
