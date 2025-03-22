return {
  'harpoon',
  for_cat = 'ui_nav',
  keys = {
    '<leader>m1',
    '<leader>m2',
    '<leader>m3',
    '<leader>m4',
    '<leader>m5',
    '<leader>mn',
    '<leader>mp',
    '<leader>mm',
    '<leader>ma',
  },

  after = function()
    local harpoon = require 'harpoon'
    harpoon:setup {}

    -- Basic telescope+harpoon configuration
    local conf = require('telescope.config').values
    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      require('telescope.pickers')
        .new({}, {
          prompt_title = 'Harpoon',
          finder = require('telescope.finders').new_table {
            results = file_paths,
          },
          previewer = conf.file_previewer {},
          sorter = conf.generic_sorter {},
        })
        :find()
    end

    -- Harpoon keymaps
    vim.keymap.set('n', '<leader>mm', function()
      toggle_telescope(harpoon:list())
    end, { desc = 'Open harpoon window' })
    vim.keymap.set('n', '<leader>ma', function()
      harpoon:list():add()
    end, { desc = 'Harpoon add file' })

    vim.keymap.set('n', '<leader>m1', function()
      harpoon:list():select(1)
    end, { desc = 'Go to harpoon buffer 1' })
    vim.keymap.set('n', '<leader>m2', function()
      harpoon:list():select(2)
    end, { desc = 'Go to harpoon buffer 2' })
    vim.keymap.set('n', '<leader>m3', function()
      harpoon:list():select(3)
    end, { desc = 'Go to harpoon buffer 3' })
    vim.keymap.set('n', '<leader>m4', function()
      harpoon:list():select(4)
    end, { desc = 'Go to harpoon buffer 4' })
    vim.keymap.set('n', '<leader>m5', function()
      harpoon:list():select(5)
    end, { desc = 'Go to harpoon buffer 5' })

    vim.keymap.set('n', '<leader>mp', function()
      harpoon:list():prev()
    end, { desc = 'Harpoon next buffer' })
    vim.keymap.set('n', '<leader>mn', function()
      harpoon:list():next()
    end, { desc = 'Harpoon previous buffer' })

    -- Configure Harpoon.
    opts = function(_, opts)
      opts.settings = {
        save_on_toggle = false,
        sync_on_ui_close = false,
        save_on_change = true,
        enter_on_sendcmd = false,
        tmux_autoclose_windows = false,
        excluded_filetypes = { 'harpoon', 'alpha', 'dashboard', 'gitcommit' },
        mark_branch = false,
        key = function()
          return vim.loop.cwd()
        end,
      }
    end

    config = function(_, opts)
      require('harpoon').setup(opts)
    end
  end,
}
