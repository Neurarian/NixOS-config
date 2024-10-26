{
  inputs,
  osConfig,
  ...
}:
let
  utils = inputs.nixCats.utils;

  extraNixdItems = pkgs: {

    nixpkgs = inputs.nixpkgs.outPath;
    flake-path = inputs.self.outPath;
    system = pkgs.system;
    systemCFGname = osConfig.networking.hostName;
  };
in
{
  imports = [
    inputs.nixCats.homeModule
  ];
  config = {
    # this value, nixCats is the defaultPackageName you pass to mkNixosModules
    # it will be the namespace for your options.
    nixCats = {
      # these are some of the options. For the rest see
      # :help nixCats.flake.outputs.utils.mkNixosModules
      # you do not need to use every option here, anything you do not define
      # will be pulled from the flake instead.
      enable = true;
      # this will add the overlays from ./overlays and also,
      # add any plugins in inputs named "plugins-pluginName" to pkgs.neovimPlugins
      # It will not apply to overall system, just nixCats.
      addOverlays = # (import ./overlays inputs) ++
        [
          (utils.standardPluginOverlay inputs)
        ];
      packageNames = [ "nvim" ];

      luaPath = "${./.}";
      # you could also import lua from the flake though, by not including this.

      # categoryDefinitions.replace will replace the whole categoryDefinitions with a new one
      categoryDefinitions.replace = (
        {
          pkgs,
          settings,
          categories,
          name,
          ...
        }@packageDef:
        {
          lspsAndRuntimeDeps = with pkgs; {
            general = [
              universal-ctags
              ripgrep
              fd
              stdenv.cc.cc
              lua54Packages.jsregexp
            ];
            debug =
              [
              ];
            bash = [
              bash-language-server
            ];
            markdown = [
              marksman
              python311Packages.pylatexenc
              harper
              markdownlint-cli
              mdformat
            ];
            rust = [
              rust-analyzer
              cargo
              rustc
              rustfmt
              # debug
              lldb
              # vscode-extensions.vadimcn.vscode-lldb
              # vscode-extensions.ms-vscode.cpptools
            ];
            lua = [
              lua-language-server
              stylua
            ];
            nix = [
              nix-doc
              nil
              nixd
              nixfmt-rfc-style
            ];
            C = [
              clang-tools
              valgrind
              cmake-language-server
              cpplint
              cmake
              cmake-format
            ];
            javascript = [
              eslint
              typescript
              typescript-language-server
              prettierd

            ];
          };
          startupPlugins = with pkgs.vimPlugins; {
            general = [
              pkgs.neovimPlugins.lz-n
              vim-sleuth
              indent-blankline-nvim
              comment-nvim
              todo-comments-nvim
              gitsigns-nvim
              which-key-nvim
              plenary-nvim
              conform-nvim
              mini-nvim
              vim-startuptime
            ];
            completion = [
              pkgs.neovimPlugins.care-nvim
              pkgs.neovimPlugins.care-cmp
              pkgs.neovimPlugins.fzy-lua-native
              pkgs.neovimPlugins.friendly-snippets
              luasnip
              cmp_luasnip
              cmp-path
              cmp-spell
              cmp-buffer
              nvim-autopairs
            ];
            tresitter = [
              otter-nvim
              nvim-treesitter.withAllGrammars
              nvim-treesitter-textobjects
            ];
            ui_nav = [
              pkgs.neovimPlugins.telescope-luasnip
              alpha-nvim
              tmux-navigator
              telescope-nvim
              telescope-fzf-native-nvim
              telescope-ui-select-nvim
              harpoon2
              nvim-colorizer-lua
              nvim-web-devicons
              catppuccin-nvim
              fidget-nvim
              neo-tree-nvim
              nui-nvim
              lualine-nvim
            ];
            lsp = [
              nvim-lspconfig
              rustaceanvim
            ];
            debug = [
              nvim-dap
              nvim-dap-ui
              nvim-dap-go
              nvim-nio
            ];
            lint = [
              nvim-lint
            ];
            # themer = with pkgs; [
            #   # you can even make subcategories based on categories and settings sets!
            #   (builtins.getAttr packageDef.categories.colorscheme {
            #       "onedark" = onedark-vim;
            #       "catppuccin" = catppuccin-nvim;
            #       "catppuccin-mocha" = catppuccin-nvim;
            #       "tokyonight" = tokyonight-nvim;
            #       "tokyonight-day" = tokyonight-nvim;
            #     }
            #   )
            # ];
          };
          optionalPlugins = {
            general = [ ];
          };
          # shared libraries to be added to LD_LIBRARY_PATH
          # variable available to nvim runtime
          sharedLibraries = {
            general = with pkgs; [
              # libgit2
            ];
          };
          environmentVariables = {
            test = {
              CATTESTVAR = "It worked!";
            };
          };
          extraWrapperArgs = {
            test = [
              ''--set CATTESTVAR2 "It worked again!"''
            ];
          };
          # lists of the functions you would have passed to
          # python.withPackages or lua.withPackages

          # get the path to this python environment
          # in your lua config via
          # vim.g.python3_host_prog
          # or run from nvim terminal via :!<packagename>-python3
          extraPython3Packages = {
            test = (_: [ ]);
          };
          # populates $LUA_PATH and $LUA_CPATH
          extraLuaPackages = {
            test = [ (_: [ ]) ];
            completion = ps: [ ps.fzy ];
          };
        }
      );

      # see :help nixCats.flake.outputs.packageDefinitions
      packages = {
        # These are the names of your packages
        # you can include as many as you wish.
        nvim =
          { pkgs, ... }:
          {
            # they contain a settings set defined above
            # see :help nixCats.flake.outputs.settings
            settings = {
              wrapRc = true;
              # IMPORTANT:
              # your alias may not conflict with your other packages.
              aliases = [
                "vim"
                "vi"
                "e"
              ];
              # neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
            };
            # and a set of categories that you want
            # (and other information to pass to lua)
            categories = {
              general = true;

              # nvim plugins
              tresitter = true;
              customPlugins = true;
              ui_nav = true;
              lsp = true;
              debug = true;
              lint = true;
              completion = true;
              have_nerd_font = true;

              # additional packages
              markdown = true;
              bash = true;
              lua = true;
              rust = true;
              nix = true;
              C = true;
              javascript = true;

              test = true;

              # Extra info to pass to lua
              nixdExtras = extraNixdItems pkgs;

              example = {
                youCan = "add more than just booleans";
                toThisSet = [
                  "and the contents of this categories set"
                  "will be accessible to your lua with"
                  "nixCats('path.to.value')"
                  "see :help nixCats"
                  "and type :NixCats to see the categories set in nvim"
                ];
              };
            };
          };
      };
    };
  };

}