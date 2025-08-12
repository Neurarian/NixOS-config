{
  user,
  pkgs,
  ...
}: {
  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";
    stateVersion = "24.05";
  };

  imports = [
    ./common
  ];
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  desktop = {
    # Enable entire hypr-ecosystem
    hypr.enable = true;
    # GUI
    applications = {
      ags.enable = true;
      cad.enable = true;
      nautilus.enable = true;
      firefox.enable = true;
      zen-browser.enable = true;
      obs.enable = true;
      # Music
      ytmusic.enable = true;
    };
    development = {
      arduino.enable = true;
    };
    theming = {
      gtk.enable = true;
    };
  };

  # Music daemon
  mpd.enable = true;

  scripts = {
    hyprlandWrapper = {
      gpuType = "amd";
    };
  };

  # Services
  systemd.user.enable = true;
  polkit_gnome.enable = true;

  wayland.windowManager.hyprland.settings = {
    monitorv2 = {
      output = "DP-1";
      mode = "3440x1440@100";
      position = "0x0";
      scale = 1;
      bitdepth = 10;
      cm = "hdr";
      sdrbrightness = 1.2;
      sdrsaturation = 1.0;
    };
    monitor = [
      "DP-2,2560x1440@144,3440x0,1"
    ];

    workspace = [
      "1, monitor:DP-1"
      "2, monitor:DP-2"
      "3, monitor:DP-1"
      "4, monitor:DP-1"
      "5, monitor:DP-1"
      "6, monitor:DP-2"
      "7, monitor:DP-2"
      "8, monitor:DP-2"
    ];
  };
}
