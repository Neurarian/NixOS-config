return {
  'otter.nvim',
  for_cat = 'treesitter',
  ft = { 'nix', 'markdown', 'ipynb', 'qmd' },
  after = function()
    require('otter').activate({ 'javascript', 'python', 'rust', 'lua', 'r' }, true, true, nil)
  end,
}
