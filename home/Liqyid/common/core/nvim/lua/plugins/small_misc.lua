return {

  {
    'Comment.nvim',
    for_cat = 'general',
    event = 'BufEnter',
    after = function()
      require('Comment').setup()
    end,
  },

  {
    'todo-comments.nvim',
    for_cat = 'general',
    event = 'BufEnter',
    after = function()
      require('todo-comments').setup()
    end,
  },

  {
    'fidget.nvim',
    for_cat = 'ui_nav',
    event = 'VimEnter',
    after = function()
      require('fidget').setup()
    end,
  },
}
