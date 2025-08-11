{
  inputs,
  self,
  ...
}: {
  flake.lib = rec {
    user = "Liqyid";

    mkPkgs = system:
      import inputs.nixpkgs {
        inherit system;
        overlays = [
          inputs.plugins-care-nvim.overlays.default
          inputs.neovim-nightly-overlay.overlays.default
          self.overlays.default
        ];
        config.allowUnfree = true;
      };

    mkSystem = hostname: {
      system ? "x86_64-linux",
      extraModules ? [],
    }:
      inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs user;
        };
        modules =
          [
            "${self}/hosts/${hostname}"
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = {
                  inherit inputs system user;
                  pkgs = mkPkgs system;
                };
                users.${user} = {
                  imports = [
                    "${self}/home/${user}/${hostname}.nix"
                    inputs.catppuccin.homeModules.catppuccin
                  ];
                };
              };
            }
          ]
          ++ extraModules;
      };
  };
}
