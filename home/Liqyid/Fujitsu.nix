{user, ...}: {
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

  # Services
  systemd.user.enable = true;
  polkit_gnome.enable = true;
}
