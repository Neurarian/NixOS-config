{
  description = "Neurarian's NixOS Flake";

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = import inputs.systems;

      imports = [
        ./devshells # Development environments
        ./formatting # Linting and formatting tools
        ./hosts # NixOS configurations
        ./lib # Utility fuctions and constants
        ./overlays # Custom package overlays
        ./packages # Package exports
      ];
    };

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

    # WM & GUI
    hyprland = {
      url = "github:hyprwm/Hyprland";
      # no follow (binary cache)
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
      url = "github:Neurarian/matshell";
      # url = "path:/home/Liqyid/Documents/matshell";
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
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nvim
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
    };
    nixCats = {
      url = "github:BirdeeHub/nixCats-nvim";
    };
    plugins-rNvim = {
      url = "github:R-nvim/R.nvim";
      flake = false;
    };
    plugins-cmp-r = {
      url = "github:R-nvim/cmp-r";
      flake = false;
    };
    plugins-snacks-luasnip = {
      # url = "path:/home/Liqyid/Documents/snacks-luasnip.nvim";
      url = "github:Neurarian/snacks-luasnip.nvim";
      flake = false;
    };
  };
}
