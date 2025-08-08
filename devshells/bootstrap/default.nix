{
  pkgs ? import <nixpkgs> {},
  shellHook,
  ...
}:
pkgs.mkShell {
  NIX_CONFIG = "extra-experimental-features = nix-command flakes ca-derivations";
  nativeBuildInputs = with pkgs; [
    nix
    home-manager
    disko
    git

    sops
    ssh-to-age
    gnupg
    age

    alejandra
    statix
    deadnix
  ];
  inherit shellHook;
}
