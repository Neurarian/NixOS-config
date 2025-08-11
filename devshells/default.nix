{self, ...}: {
  perSystem = {system, ...}: let
    pkgs = self.lib.mkPkgs system;
  in {
    devShells = {
      default = let
        inherit (self.checks.${system}.pre-commit-check) shellHook;
      in
        import ./bootstrap {inherit pkgs shellHook;};
      cellpose = import ./projects/cellpose {inherit pkgs;};
    };
  };
}
