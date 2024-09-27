return { -- Autoformat
  'conform.nvim',
  keys = { { '<leader>FF', desc = '[F]ormat [F]ile' } },
  after = function()
    local conform = require 'conform'

    conform.setup {
      formatters_by_ft = {
        lua = { 'stylua' },
        nix = { 'nixfmt' },
        go = { 'gofmt', 'golint' },
        -- Conform will run multiple formatters sequentially
        python = { 'isort', 'black' },
        c = { 'clang_format' },
        cpp = { 'clang_format' },
        cmake = { 'cmake_format' },
        -- Use a sub-list to run only the first available formatter
        javascript = { { 'prettierd', 'prettier' } },
        markdown = { 'mdformat' },
      },
    }

    vim.keymap.set({ 'n', 'v' }, '<leader>FF', function()
      conform.format {
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      }
    end, { desc = '[F]ormat [F]ile' })
  end,
}
