{inputs, ...}: {
  perSystem = {system, ...}: let
    pkgs = inputs.self.lib.mkPkgs system;
  in {
    packages = {
      inherit (pkgs) saint nixCats nixCatsStripped cellpose;
      inherit (pkgs.rPackages) nvimcom;
    };
  };
}
