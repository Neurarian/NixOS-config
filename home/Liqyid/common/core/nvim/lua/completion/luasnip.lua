return {
  'luasnip',
  for_cat = 'completion.common',
  dep_of = { 'blink-cmp.nvim' },
  after = function()
    local ls = require 'luasnip'
    require('lze').trigger_load 'friendly-snippets'
    ls.config.setup {}
    vim.tbl_map(function(type)
      require('luasnip.loaders.from_' .. type).lazy_load()
    end, { 'vscode', 'snipmate', 'lua' })
    ls.filetype_extend('typescript', { 'tsdoc' })
    ls.filetype_extend('javascript', { 'jsdoc' })
    ls.filetype_extend('lua', { 'luadoc' })
    ls.filetype_extend('python', { 'pydoc' })
    ls.filetype_extend('rust', { 'rustdoc' })
    ls.filetype_extend('cs', { 'csharpdoc' })
    ls.filetype_extend('java', { 'javadoc' })
    ls.filetype_extend('c', { 'cdoc' })
    ls.filetype_extend('cpp', { 'cppdoc' })
    ls.filetype_extend('php', { 'phpdoc' })
    ls.filetype_extend('kotlin', { 'kdoc' })
    ls.filetype_extend('ruby', { 'rdoc' })
    ls.filetype_extend('sh', { 'shelldoc' })
    vim.keymap.set({ 'i', 's' }, '<M-n>', function()
      if ls.choice_active() then
        ls.change_choice(1)
      end
    end)
  end,
}
