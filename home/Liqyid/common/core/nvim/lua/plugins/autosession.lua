return {
  'auto-session',
  for_cat = 'general',
  lazy = false,
  after = function()
    vim.o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'
    require('auto-session').setup {
      suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
    }
  end,
}
