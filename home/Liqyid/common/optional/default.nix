{lib, ...}: {
  imports = [
    ./services
    ./desktop
    ./scripts
    ./mpd.nix
    ./wezterm.nix
  ];
  mpd.enable = lib.mkDefault false;

  # Activate by default, only redundant for WSL
  wezterm.enable = lib.mkDefault true;
}
