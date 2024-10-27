return {
  'lazygit.nvim',
  after = function()
    require('telescope').load_extension 'lazygit';
    vim.keymap.set('n', '<leader>lg', function()
      require('telescope').extensions.lazygit.lazygit()
    end, { desc = 'Open Lazygit' })
  end,
}
