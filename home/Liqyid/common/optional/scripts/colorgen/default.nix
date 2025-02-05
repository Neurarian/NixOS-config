{
  lib,
  config,
  ...
}: {
  options = {
    scripts.wallpaperColorgen = {
      enable = lib.mkEnableOption "enable cologeneration for ags by wallpaper";
      output = lib.mkOption {
        type = lib.types.attrsOf lib.types.package;
        default = {};
        description = "Attribute set of all scrtipts required for desktop colorgeneration";
      };
    };
  };

  config = lib.mkIf config.scripts.wallpaperColorgen.enable {
    home.packages = builtins.attrValues config.scripts.wallpaperColorgen.output;
  };

  imports = [
    ./wal_set.nix
    ./applycolor.nix
    ./colorgen.nix
    ./generate_colors_material.nix
  ];
}
