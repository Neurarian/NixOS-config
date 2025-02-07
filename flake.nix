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
    flake-utils.url = "github:numtide/flake-utils";
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #inputs.nur.url = github:nix-community/NUR;

    # WM & GUI
    hyprland = {
      url = "github:hyprwm/Hyprland";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    Hyprspace = {

    url = "github:KZDKM/Hyprspace";
    inputs.hyprland.follows = "hyprland";
    };
    /*
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    */
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags = {
      url = "github:Aylur/ags/v1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # CPU undervolt Loki host
    vermeer-undervolt = {
      url = "github:Neurarian/5800x3d-undervolt/fixLoop";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Color scheme
    catppuccin.url = "github:catppuccin/nix";

    # Secret provisioning
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Terminal
    wezterm = {
      url = "github:wez/wezterm?dir=nix";
      # Workaround to avoid buildfailure due to outdated rust-overlay in wezterm flake
      inputs = {
        nixpkgs.follows = "nixpkgs";
        rust-overlay = {
          url = "github:oxalica/rust-overlay/master";
          inputs.nixpkgs.follows = "nixpkgs";
        };
      };
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
    plugins-arduino-nvim = {
      url = "github:stevearc/vim-arduino";
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
    flake-utils,
    pre-commit-hooks,
    ...
  } @ inputs: let
    inherit (nixpkgs) lib;
    user = "Liqyid";
    overlays = with inputs; [
      plugins-care-nvim.overlays.default
      neovim-nightly-overlay.overlays.default
      (final: _prev: {
        saint = final.callPackage ./packages/saint.nix {};
      })
    ];
    mkPkgs = system:
      import nixpkgs {
        inherit system overlays;
        config.allowUnfree = true;
      };
    mkSystem = hostname: extraModules: system:
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
                    catppuccin.homeManagerModules.catppuccin
                  ];
                };
              };
            }
          ]
          ++ extraModules;
      };
  in
    flake-utils.lib.eachDefaultSystem (system: {
      devShells = import ./shell.nix {
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
        pkgs = mkPkgs system;
      };

      packages = let
        pkgs = mkPkgs system;
        saint = pkgs.callPackage ./packages/saint.nix {};
      in {
        inherit saint;
      };

      formatter = nixpkgs.legacyPackages.${system}.alejandra;

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
    })
    // {
      nixosConfigurations = {
        Loki = mkSystem "Loki" [] "x86_64-linux";
        Medion = mkSystem "Medion" [] "x86_64-linux";
        Fujitsu = mkSystem "Fujitsu" [] "x86_64-linux";
        Wsl = mkSystem "Wsl" [] "x86_64-linux";
      };
    };
}
