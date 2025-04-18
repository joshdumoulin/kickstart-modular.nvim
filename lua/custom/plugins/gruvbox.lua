return {
  'ellisonleao/gruvbox.nvim',
  priority = 1000, -- Load early
  config = function()
    require('gruvbox').setup {
      italic = {
        strings = false,
        emphasis = false,
        comments = false,
        operators = false,
        folds = true,
      },
      dim_inactive = false,
      transparent_mode = false,
    }

    vim.cmd.colorscheme 'gruvbox'
  end,
}
