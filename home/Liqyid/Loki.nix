{user, ...}: {
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
    ags.enable = true;
    cad.enable = true;
    gtk-module.enable = true;
    nautilus.enable = true;
    fuzzel.enable = true;
    overskride.enable = true;
    firefox.enable = true;
    zen-browser.enable = true;
    wlogout.enable = true;
    # Music
    ytmusic.enable = true;
    cava.enable = true;
    arduino.enable = true;
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
    monitor = [
      "DP-1,3440x1440@100,0x0,1"
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
