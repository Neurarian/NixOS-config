{user,...}:{
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 10";
    flake = "/home/${user}/.dotfiles/nix";
  };
}
