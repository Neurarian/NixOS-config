return {
  'care.nvim',
  for_cat = 'completion.care',
  event = 'InsertEnter',
  after = function()
    local care = require 'care'

    local labels = { '1', '2', '3', '4', '5', '6', '7', '8', '9' }
    care.setup {
      ui = {
        menu = {
          max_height = 10,
          border = 'rounded',
          position = 'auto',
          format_entry = function(entry, data)
            local completion_item = entry.completion_item
            local type_icons = require('care.config').options.ui.type_icons or {}
            -- TODO: remove since now can only be number, or also allow custom string kinds?
            local entry_kind = type(completion_item.kind) == 'string' and completion_item.kind or require('care.utils.lsp').get_kind_name(completion_item.kind)

            return {
              {
                {
                  ' ' .. require('care.presets.utils').label_entries(labels)(entry, data) .. ' ',
                  'Comment',
                },
              },
              { { completion_item.label .. ' ', data.deprecated and 'Comment' or '@care.entry' } },
              {
                {
                  ' ' .. (type_icons[entry_kind] or type_icons.Text) .. ' ',
                  ('@care.type.%s'):format(entry_kind),
                },
              },
            }
          end,
          scrollbar = '█',
          alignments = {},
        },
        docs_view = {
          max_height = 8,
          max_width = 80,
          border = 'rounded',
          scrollbar = '█',
          position = 'auto',
        },
        type_icons = require 'icons',
        ghost_text = {
          enabled = true,
          position = 'inline',
        },
      },
      snippet_expansion = function(body)
        require('luasnip').lsp_expand(body)
      end,
      selection_behavior = 'select',
      confirm_behavior = 'insert',
      sources = {
        lsp = {},
        path = {
          enabled = true,
        },
        cmp_buffer = {
          enabled = true,
        },
        cmp_path = {
          enabled = true,
        },
      },
      preselect = true,
      sorting_direction = 'away-from-cursor',
      completion_events = { 'TextChangedI' },
      enabled = function()
        local enabled = true
        if vim.api.nvim_get_option_value('buftype', { buf = 0 }) == 'prompt' then
          enabled = false
        end
        return enabled
      end,
      max_view_entries = 200,
      debug = false,
    }

    vim.keymap.set('i', '<Tab>', function()
      if care.api.is_open() then
        care.api.complete()
      else
        vim.api.nvim_feedkeys(vim.keycode '<Tab>', 'n', false)
      end
    end)
    vim.keymap.set('i', '<c-p>', '<Plug>(CareSelectPrev)')
    vim.keymap.set('i', '<c-n>', '<Plug>(CareSelectNext)')
    vim.keymap.set('i', '<c-i>', '<Plug>(CareConfirm)')
    vim.keymap.set('i', '<c-e>', '<Plug>(CareClose)')

    vim.keymap.set('i', '<cr>', function()
      if care.api.is_open() and care.api.get_index() ~= 0 then
        care.api.confirm()
      else
        vim.api.nvim_feedkeys(vim.keycode '<cr>', 'n', false)
      end
    end)

    vim.keymap.set('i', '<c-f>', function()
      if care.api.doc_is_open() then
        care.api.scroll_docs(4)
      else
        vim.api.nvim_feedkeys(vim.keycode '<c-f>', 'i', false)
      end
    end)

    vim.keymap.set('i', '<c-d>', function()
      if care.api.doc_is_open() then
        care.api.scroll_docs(-4)
      else
        vim.api.nvim_feedkeys(vim.keycode '<c-f>', 'n', false)
      end
    end)

    vim.keymap.set('i', '<c-f>', function()
      if care.api.doc_is_open() then
        care.api.scroll_docs(4)
      else
        vim.api.nvim_feedkeys(vim.keycode '<c-f>', 'n', false)
      end
    end)

    for i, label in ipairs(labels) do
      vim.keymap.set('i', '<c-' .. label .. '>', function()
        care.api.select_visible(i)
        care.api.confirm()
      end)
    end

    vim.keymap.set('i', '<c-x><c-o>', function()
      care.api.complete(function(name)
        return name == 'lsp'
      end)
    end)

    vim.keymap.set('i', '<c-x><c-l>', function()
      care.api.complete(function(name)
        return name == 'cmp_buffer'
      end)
    end)

    vim.keymap.set('i', '<c-x><c-f>', function()
      care.api.complete(function(name)
        return name == 'cmp_path'
      end)
    end)

    vim.keymap.set('i', '<c-x><c-s>', function()
      care.api.complete(function(name)
        return name == 'cmp_spell'
      end)
    end)

    vim.api.nvim_create_augroup('AutoComplete', { clear = true })
    vim.api.nvim_create_autocmd('TextChangedI', {
      group = 'AutoComplete',
      callback = function()
        local function is_right_to_dot()
          local col = vim.fn.col '.' - 1
          if col == 0 then
            return false
          end
          local char_left = vim.fn.getline('.'):sub(col, col)
          return char_left == '.'
        end
        if is_right_to_dot() then
          care.api.complete()
        end
      end,
    })
  end,
}
