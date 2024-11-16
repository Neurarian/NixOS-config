{

  description = "NeurNix Flake";

  inputs = {

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

    systems = {
      url = "github:nix-systems/default-linux";
    };

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

    # CPU undervolt Loki host
    vermeer-undervolt = {
      url = "github:Neurarian/5800x3d-undervolt/fixLoop";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";

    # Zen browser

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ags = {
      url = "github:Aylur/ags/v1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    matugen = {
      url = "github:/InioX/Matugen";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    #inputs.nur.url = github:nix-community/NUR;

    # Nvim
    nixCats = {
      url = "github:BirdeeHub/nixCats-nvim";
    };

    plugins-care-nvim = {
      url = "github:max397574/care.nvim";
      flake = false;
    };

    plugins-care-cmp = {
      url = "github:max397574/care-cmp";
      flake = false;
    };

    plugins-lz-n = {
      url = "github:nvim-neorocks/lz.n";
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

    # neovim-nightly-overlay = {
    #   url = "github:nix-community/neovim-nightly-overlay";
    # };

  };

  outputs =
    {
      nixpkgs,
      home-manager,
      catppuccin,
      systems,
      ...
    }@inputs:

    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      # Default user, full gui environment
      user = "Liqyid";
      specialArgs = {
        inherit inputs system user;
      };
      forEachSystem = f: lib.genAttrs (import systems) (system: f pkgsFor.${system});
      pkgsFor = lib.genAttrs (import systems) (
        system:
        import nixpkgs {
          inherit system;
        }
      );
    in
    {
      devShells = forEachSystem (pkgs: import ./shell.nix { inherit pkgs; });

      nixosConfigurations = {

        # Main machine
        Loki = lib.nixosSystem {
          inherit specialArgs;
          modules = [
            ./hosts/Loki
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = specialArgs;
                users.${user} = {
                  imports = [
                    ./home/${user}/Loki.nix
                    catppuccin.homeManagerModules.catppuccin
                  ];
                };
              };
            }
          ];
        };

        # Medion notebook
        Medion = lib.nixosSystem {
          inherit specialArgs;
          modules = [
            ./hosts/Medion
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = specialArgs;
                users.${user} = {
                  imports = [
                    ./home/${user}/Medion.nix
                    catppuccin.homeManagerModules.catppuccin
                  ];
                };
              };
            }
          ];
        };

        # Fujitsu home lab
        Fujitsu = lib.nixosSystem {
          inherit specialArgs;
          modules = [
            ./hosts/Fujitsu
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = specialArgs;
                users.${user} = {
                  imports = [
                    ./home/${user}/Fujitsu.nix
                    catppuccin.homeManagerModules.catppuccin
                  ];
                };
              };
            }
          ];
        };
      };
    };
}
