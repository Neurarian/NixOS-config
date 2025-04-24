-- [[ Import options ]]
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

require 'core'

require('lze').register_handlers(require('utils.lze').for_cat)
require('lze').register_handlers(require('lzextras').lsp)
require('lze').load { { import = 'completion' }, { import = 'lsp' }, { import = 'plugins' } }
