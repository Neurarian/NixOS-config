-- autopairs
-- https://github.com/windwp/nvim-autopairs

return {
  'nvim-autopairs',
  for_cat = 'completion.common',
  event = 'InsertEnter',
  -- Optional dependency
  -- dependencies = { 'hrsh7th/nvim-cmp' },
  after = function()
    require('nvim-autopairs').setup {}
    -- If you want to automatically add `(` after selecting a function or method
    -- local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
    -- local cmp = require 'cmp'
    -- cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
  end,
}
