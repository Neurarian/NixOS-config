-- [[ Import options ]]
require 'core'
require 'completion'

require('lze').register_handlers(require('utils.lze').for_cat)
require('lze').load { { import = 'completion' }, { import = 'plugins' } }

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
