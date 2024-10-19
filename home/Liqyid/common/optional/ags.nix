{
  pkgs,
  lib,
  config,
  user,
  ...
}:

let
  requiredDeps = with pkgs; [
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

  cfg = config.programs.ags;

in

{
  options = {
    ags.enable = lib.mkEnableOption "enable aylurs gtk shell";
  };

  config = lib.mkIf config.ags.enable {

    home = {
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
