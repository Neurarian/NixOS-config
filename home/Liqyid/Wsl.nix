{
  user,
  pkgs,
  ...
}: let
  R-custom = pkgs.rWrapper.override {
    packages = with pkgs.rPackages; [
      tidyverse
    ];
  };
in {
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

  services.ollama = {
    enable = true;
    acceleration = "cuda";
  };

  # Host specific packages to install in user env
  home.packages = [
    R-custom
    pkgs.saint
  ];
}
