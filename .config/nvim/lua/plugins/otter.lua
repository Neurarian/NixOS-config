return {
  'otter.nvim',
  ft = { 'nix', 'markdown' },
  after = function ()
    require('otter').activate({'javascript', 'python', 'rust', 'lua'}, true, true, nil)
  end
}
