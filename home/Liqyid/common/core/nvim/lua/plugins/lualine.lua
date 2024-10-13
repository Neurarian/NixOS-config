return {
  {
    'lualine.nvim',
    event = 'VimEnter',
    after = function()
      require('lualine').setup {
        options = {
          component_separators = ' ',
          theme = 'catppuccin',
          section_separators = { left = '', right = '' },
        },
      }
    end,
  },
}
