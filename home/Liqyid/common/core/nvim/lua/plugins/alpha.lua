return {
  'alpha-nvim',
  for_cat = "ui_nav",
  event = 'VimEnter',
  after = function()
    local theta = require 'alpha.themes.theta'
    local dashboard = require 'alpha.themes.dashboard'
    vim.api.nvim_set_hl(0, 'Type', { fg = '#89B4FA' })
    vim.api.nvim_set_hl(0, 'SpecialComment', { fg = '#A6E3A1' })

    theta.header.val = {
      [[                                                                     ]],
      [[       ████ ██████           █████      ██                     ]],
      [[      ███████████             █████                             ]],
      [[      █████████ ███████████████████ ███   ███████████   ]],
      [[     █████████  ███    █████████████ █████ ██████████████   ]],
      [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
      [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
      [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
    }

    theta.header.opts.hl = {
      { { 'Type', 0, 195 } },
      { { 'SpecialComment', 0, 61 }, { 'Type', 61, 195 } },
      { { 'SpecialComment', 0, 64 }, { 'Type', 64, 195 } },
      { { 'SpecialComment', 0, 91 }, { 'Type', 91, 195 } },
      { { 'SpecialComment', 0, 86 }, { 'Type', 86, 195 } },
      { { 'SpecialComment', 0, 99 }, { 'Type', 99, 195 } },
      { { 'SpecialComment', 0, 98 }, { 'Type', 98, 195 } },
      { { 'SpecialComment', 0, 109 }, { 'Type', 109, 195 } },
      { { 'SpecialComment', 0, 195 } },
      { { 'SpecialComment', 0, 195 } },
      { { 'SpecialComment', 0, 195 } },
    }
    theta.buttons.val = {
      { type = 'text', val = 'Quick links', opts = { hl = 'Type', position = 'center' } },
      { type = 'padding', val = 1 },
      dashboard.button('e', '  New file', '<cmd>ene<CR>'),
      dashboard.button('SPC s f', '󰈞  Find file'),
      dashboard.button('SPC s g', '󰊄  Live grep'),
      dashboard.button('SPC m m', '⇁  Harpoon marks'),
      dashboard.button('SPC l g', '󰊢  LazyGit'),
      dashboard.button('c', '  Configuration', '<cmd>cd ~/.dotfiles/NixOS-config/home/Liqyid/common/core/nvim/ <CR>'),
      dashboard.button('q', '󰅚  Quit', '<cmd>qa<CR>'),
    }

    require('alpha').setup(theta.config)
  end,
}
