{
  pkgs,
  lib,
  config,
  user,
  inputs,
  ...
}:

let
  requiredDeps = with pkgs; [
    bash
    inputs.hyprland.packages.${pkgs.system}.default
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

  cfg = config.programs.ags;

in

{
  options = {
    ags.enable = lib.mkEnableOption "enable aylurs gtk shell";
  };

  config = lib.mkIf config.ags.enable {

    # packages for gradience color generation handled outside of service
    home = {
      packages = with pkgs; [
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

      # Ensure presence of colorgen dir and file
      activation = {
        makeColorgenDirs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          run mkdir -p "$XDG_STATE_HOME/ags/scss"
        '';
      };
      file = {
        "ags-state-colormode-file" = {
          target = ".local/state/ags/user/colormode.txt";
          text = ''
            dark
            opaque
            vibrant
          '';
        };
      };
    };

    programs.ags = {
      enable = true;
      configDir = config.lib.file.mkOutOfStoreSymlink /home/${user}/.dotfiles/nix/home/${user}/common/optional/ags_notebook;
    };
    systemd.user.services.ags = {
      Unit = {
        Description = "Aylur's Gtk Shell";
        PartOf = [
          "tray.target"
          "graphical-session.target"
        ];
      };
      Service = {
        Environment = "PATH=/run/wrappers/bin:${lib.makeBinPath dependencies}";
        ExecStart = "${cfg.package}/bin/ags";
        Restart = "on-failure";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
