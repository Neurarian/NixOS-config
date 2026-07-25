{
  user,
  pkgs,
  ...
}: {
  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";
    stateVersion = "26.05";
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
      mumble.enable = true;
      firefox.enable = true;
      zen-browser.enable = true;
      obs.enable = true;
      resources.enable = true;
      oversteer.enable = true;
      gnome-control-center.enable = true;
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
    monitor = [
      {
        output = "DP-1";
        mode = "3440x1440@100";
        position = "0x0";
        scale = 1;
        bitdepth = 10;
        cm = "hdr";
        sdrbrightness = 1.2;
        sdrsaturation = 1.0;
      }
      {
        output = "DP-2";
        mode = "2560x1440@144";
        position = "3440x0";
        scale = 1;
      }
      {
        output = "HDMI-A-1";
        mode = "1920x1080@60";
        position = "6000x0";
        scale = 1;
      }
    ];

    config = {
      workspace = [
        {
          id = 1;
          monitor = "DP-1";
        }
        {
          id = 2;
          monitor = "DP-2";
        }
        {
          id = 3;
          monitor = "DP-1";
        }
        {
          id = 4;
          monitor = "DP-1";
        }
        {
          id = 5;
          monitor = "DP-1";
        }
        {
          id = 6;
          monitor = "DP-2";
        }
        {
          id = 7;
          monitor = "DP-2";
        }
        {
          id = 8;
          monitor = "DP-2";
        }
      ];
    };
  };
}
