return {
  {
    'lualine.nvim',
    event = 'VimEnter',
    after = function()
      local rstt = {
        { '-', '#aaaaaa' }, -- 1: ftplugin/* sourced, but nclientserver not started yet.
        { 'S', '#757755' }, -- 2: nclientserver started, but not ready yet.
        { 'S', '#117711' }, -- 3: nclientserver is ready.
        { 'S', '#ff8833' }, -- 4: nclientserver started the TCP server
        { 'S', '#3388ff' }, -- 5: TCP server is ready
        { 'R', '#ff8833' }, -- 6: R started, but nvimcom was not loaded yet.
        { 'R', '#3388ff' }, -- 7: nvimcom is loaded.
      }

      local rstatus = function()
        if not vim.g.R_Nvim_status or vim.g.R_Nvim_status == 0 then
          -- No R file type (R, Quarto, Rmd, Rhelp) opened yet
          return ''
        end
        return rstt[vim.g.R_Nvim_status][1]
      end

      local rsttcolor = function()
        if not vim.g.R_Nvim_status or vim.g.R_Nvim_status == 0 then
          -- No R file type (R, Quarto, Rmd, Rhelp) opened yet
          return { fg = '#000000' }
        end
        return { fg = rstt[vim.g.R_Nvim_status][2] }
      end

      require('lualine').setup {
        options = {
          component_separators = ' ',
          theme = 'catppuccin',
          section_separators = { left = '', right = '' },
        },
        sections = {
          lualine_y = { { rstatus, color = rsttcolor } },
        },
      }
    end,
  },
}
