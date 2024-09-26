return {

  {
    'Comment.nvim',
    event = 'BufEnter',
    after = function()
      require('Comment').setup()
    end,
  },

  {
    'todo-comments.nvim',
    event = 'BufEnter',
    after = function()
      require('todo-comments').setup()
    end,
  },

  {
    'fidget.nvim',
    event = 'VimEnter',
    after = function()
      require('fidget').setup()
    end,
  },
}
