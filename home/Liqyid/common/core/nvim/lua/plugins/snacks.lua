-- Early setup for bigfile workaround
require('snacks').bigfile.setup()

-- Notification setup
---@diagnostic disable-next-line: duplicate-set-field
vim.notify = function(msg, level, o)
  vim.notify = Snacks.notifier.notify
  return Snacks.notifier.notify(msg, level, o)
end

local pickpick = function(name, args)
  return function()
    Snacks.picker[name](args)
  end
end

return {
  {
    'snacks-nvim',
    for_cat = 'ui_nav',
    event = { 'DeferredUIEnter' },
    load = function() end,
    keys = {
      { '<leader><leader>', pickpick 'buffers', desc = '[ ] Find existing buffers' },
      { '<leader>sh', pickpick 'help', desc = '[S]earch [H]elp' },
      { '<leader>sk', pickpick 'keymaps', desc = '[S]earch [K]eymaps' },
      { '<leader>sf', pickpick 'smart', desc = '[S]earch [F]iles' },
      { '<leader>sN', pickpick 'notifications', desc = '[N]otification History' },
      { '<leader>sw', pickpick 'grep_word', desc = '[S]earch current [W]ord', mode = { 'n', 'x' } },
      { '<leader>sg', pickpick 'grep', desc = '[S]earch by [G]rep' },
      { '<leader>sd', pickpick 'diagnostics', desc = '[S]earch [D]iagnostics' },
      { '<leader>sr', pickpick 'resume', desc = '[S]earch [R]esume' },
      { '<leader>s.', pickpick 'recent', desc = '[S]earch Recent Files ("." for repeat)' },
      { '<leader>s"', pickpick 'registers', desc = '[S]earch ["]Registers' },

      { '<leader>gL', pickpick 'git_log_line', desc = 'Git Log Line' },
      { '<leader>gd', pickpick 'git_diff', desc = 'Git Diff (Hunks)' },
      { '<leader>/', pickpick 'lines', desc = '[/] Fuzzily search in current buffer' },
      { '<leader>s/', pickpick 'grep_buffers', desc = '[S]earch [/] in Open Files' },
      { '<leader>sn', pickpick('files', { cwd = nixCats.settings.unwrappedCfgPath or nixCats.configDir }), desc = '[S]earch [N]eovim files' },
      {
        '<leader>ss',
        function()
          vim.cmd 'SessionSearch'
        end,
        desc = '[S]earch [Sessions]',
      },
      {
        '<leader>sc',
        function()
          require('snacks-luasnip').pick()
        end,
        desc = '[S]earch [C]ode snippets',
      },
      {
        '<c-/>',
        function()
          Snacks.terminal()
        end,
        mode = { 'n' },
        desc = 'Open snacks terminal',
      },
      {
        '\\',
        function()
          Snacks.explorer()
        end,
        desc = 'File Explorer',
      },
      {
        '<leader>lg',
        function()
          Snacks.lazygit.open()
        end,
        desc = 'Open Lazygit',
      },
      {
        '<leader>gl',
        function()
          Snacks.gitbrowse.open()
        end,
        mode = { 'n' },
        desc = '[G]oto git [L]ink',
      },
      {
        '<Esc>',
        function()
          Snacks.notifier.hide()
        end,
        desc = 'Dismiss notify popup',
      },
    },

    after = function(_)
      vim.api.nvim_set_hl(0, 'Lavender', { fg = '#89B4FA' })
      vim.api.nvim_set_hl(0, 'Teal', { fg = '#94e2d5' })
      Snacks.setup {
        -- bigfile = {},
        quickfile = {},
        picker = {},
        explorer = {},
        lazygit = {},
        gitbrowse = {},
        terminal = {},
        scope = {},
        indent = {},
        statuscolumn = {
          left = { 'mark', 'git' },
          right = { 'sign', 'fold' },
          folds = { open = false, git_hl = false },
          git = { patterns = { 'GitSigns.*' } },
          refresh = 50,
        },
        dashboard = {
          preset = {
            keys = {
              { icon = ' ', key = 'e', desc = 'New file', action = ':ene | startinsert' },
              {
                icon = '󰈞 ',
                key = 'f',
                desc = 'Find file',
                action = function()
                  Snacks.picker.smart()
                end,
              },
              {
                icon = '󰊄 ',
                key = 'g',
                desc = 'Live grep',
                action = function()
                  Snacks.picker.grep()
                end,
              },
              {
                icon = '󰊢 ',
                key = 'l',
                desc = 'LazyGit',
                action = function()
                  Snacks.lazygit.open()
                end,
              },
              {
                icon = '󰙅 ',
                key = '\\',
                desc = 'File tree',
                action = function()
                  Snacks.explorer()
                end,
              },
              { icon = ' ', key = 'c', desc = 'Configuration', action = ':cd ~/.dotfiles/NixOS-config/home/Liqyid/common/core/nvim/' },
              { icon = '󰅚 ', key = 'q', desc = 'Quit', action = ':qa' },
            },
          },

          sections = {
            -- Generator function to create the styled header
            function()
              local header_lines = {
                '                                                                     ',
                '       ████ ██████           █████      ██                     ',
                '      ███████████             █████                             ',
                '      █████████ ███████████████████ ███   ███████████   ',
                '     █████████  ███    █████████████ █████ ██████████████   ',
                '    █████████ ██████████ █████████ █████ █████ ████ █████   ',
                '  ███████████ ███    ███ █████████ █████ █████ ████ █████  ',
                ' ██████  █████████████████████ ████ █████ █████ ████ ██████ ',
                '                                                                       ',
                '                                                                       ',
                '                                                                       ',
              }
              local highlight_map = {
                { { 'Lavender', 0, 195 } },
                { { 'Teal', 0, 61 }, { 'Lavender', 61, 195 } },
                { { 'Teal', 0, 64 }, { 'Lavender', 64, 195 } },
                { { 'Teal', 0, 91 }, { 'Lavender', 91, 195 } },
                { { 'Teal', 0, 86 }, { 'Lavender', 86, 195 } },
                { { 'Teal', 0, 99 }, { 'Lavender', 99, 195 } },
                { { 'Teal', 0, 98 }, { 'Lavender', 98, 195 } },
                { { 'Teal', 0, 109 }, { 'Lavender', 109, 195 } },
                { { 'Teal', 0, 195 } },
                { { 'Teal', 0, 195 } },
                { { 'Teal', 0, 195 } },
              }

              local header_sections = {}

              for line_idx, line in ipairs(header_lines) do
                local line_highlights = highlight_map[line_idx]
                local text_parts = {}

                if line_highlights and #line > 0 then
                  for _, hl_spec in ipairs(line_highlights) do
                    local hl_group, start_pos, end_pos = hl_spec[1], hl_spec[2], hl_spec[3]
                    local text_part = line:sub(start_pos + 1, math.min(end_pos, #line))

                    if #text_part > 0 then
                      table.insert(text_parts, { text_part, hl = hl_group })
                    end
                  end
                else
                  table.insert(text_parts, { line, hl = 'Lavender' })
                end

                table.insert(header_sections, {
                  text = text_parts,
                  align = 'center',
                })
              end

              return header_sections
            end,

            {
              text = { { 'Recent files', hl = 'Teal' } },
              align = 'center',
              padding = 1,
            },
            { section = 'recent_files' },
            {
              text = { { 'Quick links', hl = 'Lavender' } },
              align = 'center',
              padding = { 1, 2 },
            },
            { section = 'keys' },
          },
          formats = {
            icon = function(item)
              if item.file and (item.icon == 'file') then
                return Snacks.dashboard.icon(item.file, item.icon)
              else
                return { item.icon, width = 2, hl = 'Lavender' }
              end
            end,

            key = function(item)
              if item.file and (item.icon == 'file') then
                return { { item.key, hl = 'Teal' } }
              else
                return { item.key, hl = 'Lavender' }
              end
            end,
            desc = function(item)
              return { item.desc, hl = 'SnacksPickerFile' }
            end,
            file = function(item, ctx)
              local fname = vim.fn.fnamemodify(item.file, ':~')
              fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
              if #fname > ctx.width then
                local dir = vim.fn.fnamemodify(fname, ':h')
                local file = vim.fn.fnamemodify(fname, ':t')
                if dir and file then
                  file = file:sub(-(ctx.width - #dir - 2))
                  fname = dir .. '/…' .. file
                end
              end
              local dir, file = fname:match '^(.*)/(.+)$'
              return dir and { { dir .. '/', hl = 'dir' }, { file, hl = 'SnacksPickerFile' } } or { { fname, hl = 'SnacksPickerFile' } }
            end,
          },
        },
      }
    end,
  },
}
