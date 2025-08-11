{self, ...}: {
  perSystem = {system, ...}: let
    pkgs = self.lib.mkPkgs system;
  in {
    formatter = pkgs.alejandra;
  };
}
