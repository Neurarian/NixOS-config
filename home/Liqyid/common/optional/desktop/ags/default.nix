{
  inputs,
  pkgs,
  lib,
  config,
  user,
  osConfig,
  ...
}: let
  requiredDeps = with pkgs; [
    bash
    coreutils
    dart-sass
    gawk
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
    pwvucontrol
  ];

  dependencies = requiredDeps ++ guiDeps;

  cfg = config.programs.ags;
  isMobile = osConfig.powermanagement.enable;
  agsDir =
    if isMobile
    then /home/${user}/.dotfiles/NixOS-config/home/${user}/common/optional/desktop/ags/ags_notebook
    else /home/${user}/.dotfiles/NixOS-config/home/${user}/common/optional/desktop/ags/ags_desktop;
in {
  imports = [
    inputs.ags.homeManagerModules.default
  ];

  options = {
    desktop.ags.enable = lib.mkEnableOption "enable aylurs gtk shell";
  };

  config = lib.mkIf config.desktop.ags.enable {
    home = {
      # Ensure presence of colorgen dir and file
      activation = {
        makeColorgenDirs = lib.hm.dag.entryAfter ["writeBoundary"] ''
          run mkdir -p "$XDG_STATE_HOME"/ags/{user,scss} "$XDG_CACHE_HOME"/ags/user/generated
        '';
      };
    };

    programs.ags = {
      enable = true;
      configDir = config.lib.file.mkOutOfStoreSymlink agsDir;
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
      Install.WantedBy = ["graphical-session.target"];
    };
  };
}
