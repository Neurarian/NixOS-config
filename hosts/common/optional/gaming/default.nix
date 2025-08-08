{lib, ...}: {
  imports = [
    ./scripts
    ./steam.nix
    ./vr.nix
  ];

  gaming = {
    steam.enable = lib.mkDefault false;
    vr.enable = lib.mkDefault false;
  };
}
