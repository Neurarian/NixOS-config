{
  description = "NeurNix Flake";

  inputs = {
    # Core inputs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      # url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
    };
    systems = {
      url = "systems";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #inputs.nur.url = github:nix-community/NUR;

    # WM & GUI
    hyprland = {
      url = "github:hyprwm/Hyprland";
      # no follow (binary cache)
    };
    Hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags = {
      url = "github:Aylur/ags";
      inputs.astal = {
        url = "github:Aylur/astal";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      inputs.nixpkgs.follows = "nixpkgs";
    };
    matshell = {
      url = "github:Neurarian/matshell/experimental";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # CPU undervolt Loki host
    vermeer-undervolt = {
      url = "github:Neurarian/5800x3d-undervolt/fixLoop";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Color scheme
    catppuccin.url = "github:catppuccin/nix";

    matugen = {
      url = "github:InioX/matugen";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    image-hct = {
      url = "github:Neurarian/image-hct";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secret provisioning
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Terminal
    wezterm = {
      url = "github:wez/wezterm?dir=nix";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nvim
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
    };
    nixCats = {
      url = "github:BirdeeHub/nixCats-nvim";
    };
    plugins-care-nvim = {
      url = "github:max397574/care.nvim";
      flake = true;
    };
    plugins-care-cmp = {
      url = "github:max397574/care-cmp";
      flake = false;
    };
    plugins-fzy-lua-native = {
      url = "github:romgrk/fzy-lua-native";
      flake = false;
    };
    plugins-friendly-snippets = {
      url = "github:rafamadriz/friendly-snippets";
      flake = false;
    };
    plugins-telescope-luasnip = {
      url = "github:benfowler/telescope-luasnip.nvim";
      flake = false;
    };
    plugins-rNvim = {
      url = "github:R-nvim/R.nvim";
      flake = false;
    };
    plugins-cmp-r = {
      url = "github:R-nvim/cmp-r";
      flake = false;
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    catppuccin,
    flake-parts,
    pre-commit-hooks,
    self,
    ...
  } @ inputs: let
    inherit (nixpkgs) lib;
    user = "Liqyid";
    overlays = with inputs; [
      plugins-care-nvim.overlays.default
      /*
      neovim-nightly-overlay.overlays.default
      */
      (final: _prev: {
        # I think this is a kinda ugly, hacky way of calling and overlaying the custom nixCats package.
        # But I want to have it easily available in pure nix-shells and keep it integrated as a module.
        nixCats = self.nixosConfigurations.Loki.config.home-manager.users.${user}.nixCats.out.packages.nvimFull;
        nixCatsStripped = self.nixosConfigurations.Loki.config.home-manager.users.${user}.nixCats.out.packages.nvimStripped;

        saint = final.callPackage ./packages/saint.nix {};
      })
    ];

    mkPkgs = system:
      import nixpkgs {
        inherit system overlays;
        config.allowUnfree = true;
      };

    mkSystem = hostname: {
      system ? "x86_64-linux",
      extraModules ? [],
    }:
      lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs user;
        };
        modules =
          [
            ./hosts/${hostname}
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = {
                  inherit inputs system user;
                  pkgs = mkPkgs system;
                };
                users.${user} = {
                  imports = [
                    ./home/${user}/${hostname}.nix
                    catppuccin.homeModules.catppuccin
                  ];
                };
              };
            }
          ]
          ++ extraModules;
      };
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = import inputs.systems;

      perSystem = {system, ...}: let
        pkgs = mkPkgs system;
      in {
        # For bootstrapping
        devShells =
          import ./shell.nix
          {
            shellHook =
              pre-commit-hooks.lib.${system}.run
              {
                src = ./.;
                hooks = {
                  alejandra.enable = true;
                  statix.enable = true;
                  deadnix = {
                    enable = true;
                    args = ["--no-lambda-pattern-names"];
                  };
                };
              }
              .shellHook;
            inherit pkgs;
          };

        # Custom packages or patched binaries not in nixpkgs
        packages = {
          inherit (pkgs) saint nixCats nixCatsStripped;
        };

        formatter = pkgs.alejandra;

        checks.pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            alejandra.enable = true;
            statix.enable = true;
            deadnix = {
              enable = true;
              args = ["--no-lambda-pattern-names"];
            };
          };
        };
      };

      flake = {
        nixosConfigurations = {
          Loki = mkSystem "Loki" {};
          Medion = mkSystem "Medion" {};
          Fujitsu = mkSystem "Fujitsu" {};
          Wsl = mkSystem "Wsl" {};
        };
      };
    };
}
