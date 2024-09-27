return {
    -- Add indentation guides even on blank lines
    'indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    event = "VimEnter",
    after = function()
      main = 'ibl'
      require('ibl').setup()
    end,
}
