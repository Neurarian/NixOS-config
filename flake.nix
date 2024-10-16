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
      url = "path:/home/Liqyid/.dotfiles/nix/home/Liqyid/common/core/nvim";
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
      user = "Liqyid";
    in
    {
      nixosConfigurations = {
        NixOS = lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit inputs user;
          };
          modules = [
            inputs.disko.nixosModules.disko
            inputs.catppuccin.nixosModules.catppuccin
            inputs.sops-nix.nixosModules.sops
            ./hosts/medionnb
          ];
        };
      };
      homeConfigurations = {
        ${user} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          extraSpecialArgs = {
            inherit inputs user system;
          };

          modules = [
            ./home/Liqyid/medionnb.nix
            inputs.ags.homeManagerModules.default
            inputs.catppuccin.homeManagerModules.catppuccin
            inputs.nixCats.homeModule
          ];
        };
      };
    };
}
