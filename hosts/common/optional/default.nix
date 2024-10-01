{ lib, ... }:
{
  imports = [
    ./nvidia.nix
    ./localsend.nix
    ./services
    ./powermanagement.nix
    ./zsh.nix
  ];
  localsend.enable = lib.mkDefault false;
  zsh.enable = lib.mkDefault false;
  powermanagement.enable = lib.mkDefault false;
}
