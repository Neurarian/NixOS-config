{
  pkgs,
  lib,
  config,
  ...
}:

let
  requiredDeps = with pkgs; [
    config.wayland.windowManager.hyprland.package
    bash
    coreutils
    dart-sass
    gawk
    imagemagick
    inotify-tools
    procps
    ripgrep
    util-linux
  ];

  guiDeps = with pkgs; [
    gnome-control-center
    mission-center
    overskride
    wlogout
  ];

  dependencies = requiredDeps ++ guiDeps;

in
# cfg = config.programs.ags;
{
  options = {
    ags.enable = lib.mkEnableOption "enable aylurs gtk shell";
  };

  config = lib.mkIf config.ags.enable {

    home = {
      packages = with pkgs; [
        dart-sass
        gradience
        (pkgs.python3.withPackages (python-pkgs: [
          python-pkgs.setuptools-scm
          python-pkgs.pillow
          python-pkgs.build
          python-pkgs.material-color-utilities
          python-pkgs.materialyoucolor
          python-pkgs.libsass
          python-pkgs.wheel
        ]))
      ];

# TODO: use home.activation or find some other way to create the necessary dirs for gradience color gen
      /* file = {
        "ags-state-colormode-file" = {
          target = ".local/state/ags/user/colormode.txt";
          text = ''
            dark
            opaque
            vibrant
          '';
        };
        "ags-state-scss-file" = {
          target = ".local/state/ags/scss/_material.scss";
          text = ''
            dark
            opaque
            vibrant
          '';
        };
      };*/
    }; 

    programs.ags = {
      enable = true;
      # configDir = ./ags;
      extraPackages = dependencies;
      systemd.enable = true;
    };
  };
}
