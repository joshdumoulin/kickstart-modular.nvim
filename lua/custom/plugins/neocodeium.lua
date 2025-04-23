-- lua/plugins/neocodeium.lua
return {
  {
    'monkoose/neocodeium',
    -- Ensures blink.cmp is available when this config runs
    dependencies = { 'saghen/blink.cmp' },
    event = 'VeryLazy',
    config = function()
      local neocodeium_ok, neocodeium = pcall(require, 'neocodeium')
      local blink_ok, blink = pcall(require, 'blink.cmp')

      if not neocodeium_ok then
        vim.notify('NeoCodeium failed to load.', vim.log.levels.ERROR)
        return
      end

      neocodeium.setup {
        -- Filter: Prevent NeoCodeium suggestions when blink.cmp menu is visible
        filter = function()
          if blink_ok then
            return not blink.is_visible()
          else
            return true -- Allow if blink isn't loaded
          end
        end,
      }

      -- Autocmd: Clear NeoCodeium suggestion when blink.cmp menu opens to avoid overlap
      vim.api.nvim_create_autocmd('User', {
        pattern = 'BlinkCmpMenuOpen',
        group = vim.api.nvim_create_augroup('NeocodeiumBlinkIntegration', { clear = true }),
        callback = function()
          neocodeium.clear()
        end,
        desc = 'Clear NeoCodeium suggestion when Blink menu opens',
      })

      -- Basic keymap to accept suggestions
      vim.keymap.set('i', '<A-f>', function()
        local nc_ok, nc = pcall(require, 'neocodeium')
        if nc_ok then
          nc.accept()
        end
      end, { desc = 'NeoCodeium: Accept suggestion' })

      vim.keymap.set('i', '<A-e>', function()
        require('neocodeium').cycle_or_complete()
      end)

      -- Remember to run :NeoCodeium auth the first time!
    end, -- end config function
  }, -- end plugin spec table
} -- end return statement

-- return {
--   'monkoose/neocodeium',
--   event = 'VeryLazy',
--   config = function()
--     local neocodeium = require 'neocodeium'
--     neocodeium.setup()
--     vim.keymap.set('i', '<A-f>', neocodeium.accept)
--   end,
-- }
