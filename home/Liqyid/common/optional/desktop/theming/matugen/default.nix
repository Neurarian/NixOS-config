# Not in use for now
# handled by matshell
{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.matugen.nixosModules.default
  ];
  options = {
    desktop.matugen.enable = lib.mkEnableOption "enable matugen colorgen";
  };

  config = lib.mkIf config.desktop.matugen.enable {
    home.packages = [inputs.matugen.packages.${pkgs.system}.default];

    home.file.".config/matugen/config.toml".text = let
      gtkTemplate = builtins.path {path = ./templates/gtk.css;};
      agsTemplate = builtins.path {path = ./templates/ags.scss;};
      hyprTemplate = builtins.path {path = ./templates/hyprland_colors.conf;};
      hyprlockTemplate = builtins.path {path = ./templates/hyprlock_colors.conf;};
    in ''
      [templates.gtk3]
      input_path = "${gtkTemplate}"
      output_path = "~/.config/gtk-3.0/gtk.css"

      [templates.gtk4]
      input_path = "${gtkTemplate}"
      output_path = "~/.config/gtk-4.0/gtk.css"

      [templates.ags]
      input_path = "${agsTemplate}"
      output_path = "~/.config/ags/style/colors.scss"

      [templates.hypr]
      input_path = "${hyprTemplate}"
      output_path = "~/.config/hypr/hyprland_colors.conf"

      [templates.hyprlock]
      input_path = "${hyprlockTemplate}"
      output_path = "~/.config/hypr/hyprlock_colors.conf"

      [config.custom_colors]
    '';
  };
}
