local function on_attach(_, bufnr)
  local map = function(keys, func, desc, mode)
    if desc then
      desc = 'LSP: ' .. desc
    end
    vim.keymap.set(mode or 'n', keys, func, { buffer = bufnr, desc = desc })
  end

  -- Core LSP functionality
  map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
  map('K', vim.lsp.buf.hover, 'Hover Documentation')
  map('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Telescope integrations
  map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
  map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
  map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

  -- Create a Format command
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

return {
  {
    -- Doesn't load nvim-lspconfig, this just handles the global LSP configuration
    'lsp-handler',
    for_cat = 'general',
    lsp = function(plugin)
      -- This processes each plugin with an 'lsp' field
      vim.lsp.config(plugin.name, plugin.lsp or {})
      vim.lsp.enable(plugin.name)
    end,
    before = function(_)
      -- Set global defaults
      vim.lsp.config['*'] = {
        on_attach = on_attach,
      }
    end,
  },

  -- Individual LSP entries that match my nixCats categories
  {
    'marksman',
    for_cat = 'markdown',
    lsp = {
      cmd = { 'marksman', 'server' },
      filetypes = { 'markdown' },
      root_markers = { '.git', 'README.md' },
    },
  },

  {
    'harper_ls',
    for_cat = 'markdown',
    lsp = {
      cmd = { 'harper-ls' },
      filetypes = { 'markdown', 'norg' },
      root_markers = { '.git', 'README.md' },
      settings = {
        ['harper-ls'] = {},
      },
    },
  },

  {
    'cmake',
    for_cat = 'C',
    lsp = {
      cmd = { 'cmake-language-server' },
      filetypes = { 'cmake' },
      root_markers = { '.git', 'CMakeLists.txt' },
    },
  },

  {
    'nixd',
    for_cat = 'nix',
    lsp = {
      cmd = { 'nixd' },
      filetypes = { 'nix' },
      root_markers = { '.git', 'flake.nix', 'default.nix' },
      settings = {
        nixd = {
          nixpkgs = {
            expr = 'import <nixpkgs> { }',
          },
          formatting = {
            command = { 'alejandra' },
          },
          options = {
            nixos = {
              expr = [[(builtins.getFlake "]]
                .. nixCats 'nixdExtras.flake-path'
                .. [[").nixosConfigurations."]]
                .. nixCats 'nixdExtras.systemCFGname'
                .. [[".options]],
            },
          },
        },
      },
    },
  },

  {
    'bashls',
    for_cat = 'bash',
    lsp = {
      cmd = { 'bash-language-server', 'start' },
      filetypes = { 'sh', 'bash' },
      root_markers = { '.git', '.bashrc' },
    },
  },

  {
    'tsserver',
    for_cat = 'javascript',
    lsp = {
      cmd = { 'typescript-language-server', '--stdio' },
      filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact' },
      root_markers = { '.git', 'tsconfig.json', 'package.json' },
    },
  },

  {
    'lua_ls',
    for_cat = 'lua',
    lsp = {
      cmd = { 'lua-language-server' },
      filetypes = { 'lua' },
      root_markers = { '.git', '.luarc.json', '.stylua.toml' },
      settings = {
        Lua = {
          completion = {
            callSnippet = 'Replace',
          },
          diagnostics = { disable = { 'missing-fields' } },
        },
      },
    },
  },

  {
    'r_language_server',
    for_cat = 'R',
    lsp = {
      cmd = { 'R', '--slave', '-e', 'languageserver::run()' },
      filetypes = { 'r', 'rmd' },
      root_markers = { '.git', '.Rproj' },
    },
  },

  {
    'arduino_language_server',
    for_cat = 'arduino',
    lsp = {
      cmd = { 'arduino-language-server' },
      filetypes = { 'arduino', 'ino' },
      root_markers = { '.git' },
    },
  },
}
