return {
  'auto-session',
  for_cat = 'general',
  lazy = false,
  after = function()
    require('auto-session').setup {
      suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
    }
  end,
}
