{
  inputs,
  osConfig,
  pkgs,
  system,
  ...
}: let
  inherit (inputs.nixCats) utils;

  extraNixdItems = {
    inherit (pkgs.stdenv.hostPlatform) system;
    nixpkgs = inputs.nixpkgs.outPath;
    flake-path = inputs.self.outPath;
    systemCFGname = osConfig.networking.hostName;
  };

  R-custom = pkgs.rWrapper.override {
    # Only core packages to manage rix. Use rix generated nix-shells for actual projects.
    packages = with pkgs.rPackages; [
      rix
      here
      pacman
      inputs.plugins-rNvim.packages.${system}.nvimcom
    ];
  };

  quarto-patched = pkgs.quarto.overrideAttrs (old: {
    postFixup =
      (old.postFixup or "")
      + ''
        substituteInPlace $out/bin/quarto.js \
        --replace-fail 'kSyntaxHighlighting = "syntax-highlighting"' 'kSyntaxHighlighting = "highlight-style"' \
        --replace-fail '"--syntax-highlighting"' '"--highlight-style"'
        substituteInPlace $out/share/filters/modules/jog.lua \
        --replace-fail "elseif tp == 'pandoc TableHead' or tp == 'pandoc TableFoot' or" "elseif tp == 'pandoc TableBody' or tp == 'TableBody' then
        element.head = jogger(element.head)
        element.body = jogger(element.body)
        elseif tp == 'pandoc TableHead' or tp == 'pandoc TableFoot' or"
      '';
  });
in {
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
      nixpkgs_version = inputs.nixpkgs;
      # this will add the overlays from ./overlays and also,
      # add any plugins in inputs named "plugins-pluginName" to pkgs.neovimPlugins
      # It will not apply to overall system, just nixCats.
      addOverlays =
        # (import ./overlays inputs) ++
        [
          (utils.standardPluginOverlay inputs)
        ];
      packageNames = ["nvimFull" "nvimStripped"];

      luaPath = "${./.}";
      # you could also import lua from the flake though, by not including this.

      # categoryDefinitions.replace will replace the whole categoryDefinitions with a new one
      categoryDefinitions.replace = {
        pkgs,
        settings,
        categories,
        name,
        ...
      }: {
        lspsAndRuntimeDeps = {
          general = [
            pkgs.universal-ctags
            pkgs.ripgrep
            pkgs.fd
            pkgs.lua54Packages.jsregexp
          ];
          git = [
            pkgs.git
            pkgs.lazygit
          ];
          debug = [
            pkgs.lldb
          ];
          bash = [
            pkgs.bash-language-server
          ];
          markdown = [
            pkgs.marksman
            pkgs.python311Packages.pylatexenc
            pkgs.harper
            pkgs.markdownlint-cli
            pkgs.mdformat
            quarto-patched
          ];
          rust = [
            pkgs.rust-analyzer
            pkgs.cargo
            pkgs.rustc
            pkgs.rustfmt
          ];
          lua = [
            pkgs.lua-language-server
            pkgs.stylua
          ];
          nix = [
            pkgs.nix-doc
            pkgs.nil
            pkgs.nixd
            pkgs.alejandra
          ];
          C = [
            pkgs.stdenv.cc.cc
            pkgs.clang-tools
            pkgs.valgrind
            pkgs.cmake-language-server
            pkgs.cpplint
            pkgs.cmake
            pkgs.cmake-format
          ];
          javascript = [
            pkgs.eslint
            pkgs.typescript
            pkgs.typescript-language-server
            pkgs.prettierd
          ];
          R = [
            R-custom
            pkgs.gcc
            pkgs.gnumake
          ];
          arduino = [
            pkgs.arduino-cli
            pkgs.arduino-language-server
          ];
          ui_nav = [
            # Snacks Picker
            pkgs.sqlite
          ];
        };
        startupPlugins = {
          general = [
            pkgs.vimPlugins.lze
            pkgs.vimPlugins.lzextras
            pkgs.vimPlugins.vim-sleuth
            pkgs.vimPlugins.comment-nvim
            pkgs.vimPlugins.todo-comments-nvim
            pkgs.vimPlugins.which-key-nvim
            pkgs.vimPlugins.plenary-nvim
            pkgs.vimPlugins.mini-nvim
            pkgs.vimPlugins.vim-startuptime
            pkgs.vimPlugins.auto-session
          ];
          format = [
            pkgs.vimPlugins.conform-nvim
          ];
          git = [
            pkgs.vimPlugins.gitsigns-nvim
          ];
          R = [
            inputs.plugins-rNvim.packages.${system}.default
          ];
          markdown = [
            pkgs.vimPlugins.markview-nvim
          ];
          completion = {
            common = [
              pkgs.vimPlugins.friendly-snippets
              pkgs.vimPlugins.luasnip
              pkgs.vimPlugins.cmp_luasnip
              pkgs.vimPlugins.cmp-path
              pkgs.vimPlugins.cmp-spell
              pkgs.vimPlugins.cmp-buffer
              pkgs.vimPlugins.nvim-autopairs
            ];
            blink = [
              pkgs.vimPlugins.blink-cmp
              pkgs.vimPlugins.blink-compat
              pkgs.neovimPlugins.cmp-r
            ];
          };
          treesitter = [
            pkgs.vimPlugins.otter-nvim
            (pkgs.vimPlugins.nvim-treesitter.withPlugins (p:
              with p; [
                rust
                nix
                python
                c
                lua
                r
                bash
                rnoweb
                yaml
                markdown
                markdown_inline
                regex
              ]))
            pkgs.vimPlugins.nvim-treesitter-textobjects
          ];
          ui_nav = [
            pkgs.vimPlugins.vim-tmux-navigator
            pkgs.vimPlugins.nvim-colorizer-lua
            pkgs.vimPlugins.nvim-web-devicons
            pkgs.vimPlugins.catppuccin-nvim
            pkgs.vimPlugins.fidget-nvim
            pkgs.vimPlugins.snacks-nvim
            pkgs.neovimPlugins.snacks-luasnip
            pkgs.neovimPlugins.snacks-zotero
            pkgs.vimPlugins.sqlite-lua
            pkgs.vimPlugins.lualine-nvim
          ];
          rust = [
            pkgs.vimPlugins.rustaceanvim
          ];
          debug = [
            pkgs.vimPlugins.nvim-dap
            pkgs.vimPlugins.nvim-dap-ui
            pkgs.vimPlugins.nvim-dap-go
            pkgs.vimPlugins.nvim-nio
          ];
          lint = [
            pkgs.vimPlugins.nvim-lint
          ];
        };
        optionalPlugins = {
          general = [];
        };
        # shared libraries to be added to LD_LIBRARY_PATH
        # variable available to nvim runtime
        sharedLibraries = {
          general = [
            # pgks.libgit2
          ];
          ui_nav = [
            pkgs.sqlite.out
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
        python3.libraries = {
          test = _: [];
        };
        # populates $LUA_PATH and $LUA_CPATH
        extraLuaPackages = {
          test = [(_: [])];
          completion = ps: [ps.fzy];
        };
      };

      # see :help nixCats.flake.outputs.packageDefinitions
      packageDefinitions.replace = {
        # These are the names of your packages
        # you can include as many as you wish.
        nvimFull = _: {
          # they contain a settings set defined above
          # see :help nixCats.flake.outputs.settings
          settings = {
            wrapRc = true;
            # IMPORTANT:
            # your alias may not conflict with your other packages.
            aliases = [
              "nvim"
              "vim"
              "vi"
              "e"
            ];
          };
          # and a set of categories that you want
          # (and other information to pass to lua)
          categories = {
            general = true;

            # nvim plugins
            treesitter = true;
            git = true;
            customPlugins = true;
            ui_nav = true;
            format = true;
            debug = true;
            lint = true;
            completion = {
              common = true;
              blink = true;
            };
            have_nerd_font = true;
            arduino = true;

            # additional packages
            markdown = true;
            bash = true;
            lua = true;
            # rust = true;
            nix = true;
            C = true;
            javascript = true;
            R = true;

            test = true;

            # Extra info to pass to lua
            nixdExtras = extraNixdItems;
          };
        };

        nvimStripped = _: {
          # they contain a settings set defined above
          # see :help nixCats.flake.outputs.settings
          settings = {
            wrapRc = true;
            # IMPORTANT:
            # your alias may not conflict with your other packages.
            aliases = [
              "nixCats"
            ];
          };
          # and a set of categories that you want
          # (and other information to pass to lua)
          categories = {
            general = true;

            # nvim plugins
            tresitter = true;
            git = true;
            customPlugins = true;
            ui_nav = true;
            format = true;
            lint = true;
            completion = {
              common = true;
              blink = true;
            };
            have_nerd_font = true;
            arduino = true;

            # additional packages
            markdown = true;
            bash = true;
            lua = true;
            nix = true;

            test = true;

            # Extra info to pass to lua
            nixdExtras = extraNixdItems;
          };
        };
      };
    };
  };
}
