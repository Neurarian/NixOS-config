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
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixCats = {
      url = "path:/home/Liqyid/.dotfiles/NixOS-config/home/Liqyid/common/core/nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

  };

  outputs =
    {
      nixpkgs,
      home-manager,
      ...
    }@inputs:

    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
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
          ];
        };
      };

      homeConfigurations = {

        "${user}@Loki" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          extraSpecialArgs = {
            inherit inputs user system;
          };

          modules = [
            ./home/${user}/Loki.nix
            inputs.catppuccin.homeManagerModules.catppuccin
          ];
        };

        "${user}@Medion" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          extraSpecialArgs = {
            inherit inputs user system;
          };

          modules = [
            ./home/${user}/Medion.nix
            inputs.catppuccin.homeManagerModules.catppuccin
          ];
        };


        "${user}@Fujitsu" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          extraSpecialArgs = {
            inherit inputs user system;
          };

          modules = [
            ./home/${user}/Fujitsu.nix
            inputs.catppuccin.homeManagerModules.catppuccin
          ];
        };
      };
    };
}
