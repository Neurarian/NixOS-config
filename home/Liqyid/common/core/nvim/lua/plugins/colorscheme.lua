return {
  'catppuccin-nvim',
  priority = 1000, -- Make sure to load this before all the other start plugins.
  after = function()
    require('catppuccin').setup {

      integrations = {
          neotree = true,
        },
      }
    vim.cmd.colorscheme 'catppuccin-mocha'
    vim.cmd.hi 'Comment gui=none'
    vim.g.rout_follow_colorscheme = true
  end,
}
