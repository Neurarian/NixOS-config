return {
  'lazygit.nvim',
  keys = {
    '<leader>lg',
  },
  after = function()
    vim.keymap.set('n', '<leader>lg', '<cmd>LazyGit<CR>', { desc = 'Open Lazygit' })

    -- Integrate with telescope to switch between repos quicker.
    vim.keymap.set('n', '<leader>sl', function()
      require('telescope').extensions.lazygit.lazygit()
    end, { desc = 'Seach Lazygit repos' })

  end,
}
