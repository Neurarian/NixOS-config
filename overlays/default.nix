{
  inputs,
  self,
  ...
}: {
  flake.overlays.default = let
    pack = "${self}/packages/";
    pyPack = "${pack}/python/";
    nvimPack = self.nixosConfigurations.Loki.config.home-manager.users.${self.lib.user}.nixCats.out.packages;
  in
    final: prev: {
      # Nvim packages
      nixCats = nvimPack.nvimFull;
      nixCatsStripped = nvimPack.nvimStripped;

      # Patched binaries
      saint = prev.callPackage "${pack}/saint.nix" {};

      # Python packages
      roifile = prev.python312Packages.callPackage "${pyPack}/roifile.nix" {};
      fill-voids = prev.python312Packages.callPackage "${pyPack}/fill-voids.nix" {};
      segment-anything = prev.python312Packages.callPackage "${pyPack}/segment-anything.nix" {};
      cellpose = prev.python312Packages.callPackage "${pyPack}/cellpose.nix" {
        inherit (final) roifile fill-voids segment-anything;
      };

      # R packages
      rPackages =
        prev.rPackages
        // {
          nvimcom = prev.callPackage "${pack}/R/nvimcom.nix" {
            rNvim = inputs.plugins-rNvim;
          };
        };
      # Workaround: liquidctl 1.16.0 has a flaky inter-process file-locking
      # test that fails in the Nix sandbox (fcntl locks unreliable on sandbox
      # tmpfs across forked processes), blocking coolercontrold from building.
      python313Packages = prev.python313Packages.overrideScope (pyFinal: pyPrev: {
        liquidctl = pyPrev.liquidctl.overrideAttrs (old: {
          disabledTests =
            (old.disabledTests or [])
            ++ [
              "test_fs_backend_stores_honor_load_store_locking"
            ];
        });
      });
    };
}
