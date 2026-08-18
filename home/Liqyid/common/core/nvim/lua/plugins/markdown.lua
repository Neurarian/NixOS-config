return {
  'markview.nvim',
  for_cat = 'markdown',
  ft = 'markdown',
  after = function()
    require('markview').setup {
      preview = {
        mode = { 'n', 'no', 'c' },
        icon_provider = 'devicons',
      },
      markdown = {
        headings = { enable = true },
        tables = { enable = true },
      },
    }
  end,
}
