{

  description = "NeurNix Flake";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    catppuccin.url = "github:catppuccin/nix";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      # url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    /*
      hyprland-plugins = {
        url = "github:hyprwm/hyprland-plugins";
        inputs.hyprland.follows = "hyprland";
      };
    */

    Hyprspace = {

      url = "github:myamusashi/Hyprspace"; # Temporary fix
      # url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    /*
      nixCats = {
        url = "path:/home/Liqyid/.dotfiles/NixOS-config/home/Liqyid/common/core/nvim";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    */

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wezterm = {
      url = "github:Neurarian/wezterm?dir=nix";
      # url = "github:wez/wezterm?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #inputs.nur.url = github:nix-community/NUR;

    # Nvim
    nixCats = {
      url = "github:BirdeeHub/nixCats-nvim";
      inputs.nixpkgs.follows = "nixpkgs";
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
      ...
    }@inputs:

    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      # pkgs = nixpkgs.legacyPackages.${system};
      # Default user, full gui environment
      user = "Liqyid";
    in
    {
      nixosConfigurations = {

        # Main machine
        Loki = lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit inputs user;
          };

          modules = [
            ./hosts/Loki
            home-manager.nixosModules.home-manager
            {
              home-manager = {

                extraSpecialArgs = {
                  inherit inputs user system;
                };

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
          inherit system;

          specialArgs = {
            inherit inputs user;
          };

          modules = [
            ./hosts/Medion
            home-manager.nixosModules.home-manager
            {
              home-manager = {

                extraSpecialArgs = {
                  inherit inputs user system;
                };

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
          inherit system;

          specialArgs = {
            inherit inputs user;
          };

          modules = [
            ./hosts/Fujitsu
            home-manager.nixosModules.home-manager
            {
              home-manager = {

                extraSpecialArgs = {
                  inherit inputs user system;
                };

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
