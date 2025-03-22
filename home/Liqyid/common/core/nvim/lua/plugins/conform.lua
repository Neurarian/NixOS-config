return { -- Autoformat
  'conform.nvim',
  for_cat = 'format',
  keys = { { '<leader>FF', desc = '[F]ormat [F]ile' } },
  after = function()
    local conform = require 'conform'
    local js = { 'prettierd', 'prettier', stop_after_first = true }

    conform.setup {
      formatters_by_ft = {
        lua = { 'stylua' },
        nix = { 'alejandra' },
        go = { 'gofmt', 'golint' },
        python = { 'isort', 'black' },
        c = { 'clang_format' },
        cpp = { 'clang_format' },
        cmake = { 'cmake_format' },
        javascript = js,
        typescript = js,
        typescriptreact = js,
        markdown = { 'mdformat' },
      },
    }

    vim.keymap.set({ 'n', 'v' }, '<leader>FF', function()
      conform.format {
        lsp_fallback = true,
        async = false,
        timeout_ms = 3000,
      }
    end, { desc = '[F]ormat [F]ile' })
  end,
}
