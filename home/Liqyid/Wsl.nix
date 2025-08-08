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

  # Host specific packages to install in user env
  home.packages = [
    pkgs.saint
    pkgs.cudatoolkit
  ];
}
