return {

  {
    -- For adding addtional sources in the future
    'blink.compat',
    for_cat = 'completion.blink',
  },
  {
    'blink-cmp.nvim',
    for_cat = 'completion.blink',
    event = 'InsertEnter',
    after = function()
      require('blink.cmp').setup {

        keymap = {
          preset = 'super-tab',
          ['<C-i>'] = { 'select_and_accept' },
          ['<CR>'] = { 'accept', 'fallback' },
          ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
          ['<C-d>'] = { 'scroll_documentation_up', 'fallback' },
        },

        appearance = {
          nerd_font_variant = 'mono',
          kind_icons = require 'icons',
        },

        signature = {
          enabled = true,
          window = {
            border = 'rounded',
          },
        },

        completion = {
          menu = {
            enabled = true,
            border = 'rounded',
            scrollbar = false,
            draw = {
              columns = { { 'label', 'label_description', gap = 1 }, { 'kind_icon' } },
            },
          },

          documentation = {
            auto_show = true,
            auto_show_delay_ms = 500,
            treesitter_highlighting = true,
            window = {
              min_width = 20,
              max_width = 80,
              max_height = 8,
              border = 'rounded',
              scrollbar = false,
            },
          },

          ghost_text = {
            enabled = true,
          },
        },

        snippets = { preset = 'luasnip' },

        sources = {
          default = { 'lsp', 'path', 'buffer', 'snippets' },
          providers = {
            -- create provider
            cmp_r = {
              -- IMPORTANT: use the same name as you would for nvim-cmp
              name = 'cmp_r',
              module = 'blink.compat.source',
            },
          },
        },

        fuzzy = {
          implementation = 'prefer_rust_with_warning',
        },
      }
    end,
  },
}
