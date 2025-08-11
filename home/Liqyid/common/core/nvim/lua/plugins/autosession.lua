return {
  'auto-session',
  for_cat = 'general',
  lazy = false,
  after = function()
    require('auto-session').setup {
      opts = {
        suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
      },
    }
  end,
}
