--[[
 ██████╗ ██████╗ ███╗   ███╗██████╗ ██╗     ███████╗████████╗██╗ ██████╗ ███╗   ██╗
██╔════╝██╔═══██╗████╗ ████║██╔══██╗██║     ██╔════╝╚══██╔══╝██║██╔═══██╗████╗  ██║
██║     ██║   ██║██╔████╔██║██████╔╝██║     █████╗     ██║   ██║██║   ██║██╔██╗ ██║
██║     ██║   ██║██║╚██╔╝██║██╔═══╝ ██║     ██╔══╝     ██║   ██║██║   ██║██║╚██╗██║
╚██████╗╚██████╔╝██║ ╚═╝ ██║██║     ███████╗███████╗   ██║   █║╚██████╔╝██║ ╚████║
 ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝     ╚══════╝╚══════╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝
Code completion is a feature in which the editor suggests completions for the current word
or symbol. This can be helpful for writing code faster and with fewer errors. There are many
plugins available for code completion in Neovim.

My Choice:
[copilot.vim](https://github.com/github/copilot.vim) Built by Tim Pope (tpope) and uses the OpenAI Codex.

Alternatives:
- [copilot-cmp](https://github.com/zbirenbaum/copilot-cmp) Integrates GitHub Copilot with nvim-cmp source
- [Tabnine](https://github.com/codota/tabnine-nvim) Tabnine AI-powered code completion
- [Codeium](https://github.com/Exafunction/codeium.nvim) Codeium's AI-powered coding assistant
- [Minuet](https://github.com/milanglacier/minuet-ai.nvim) - Support for multiple LLMs

--]]

return {
  'github/copilot.vim',
  enabled = true,
  event = { 'BufReadPost', 'BufNewFile' },
  init = function()
    -- State file path
    local state_file = vim.fn.stdpath 'state' .. '/copilot_state.txt'

    -- Read initial state from file (if exists)
    if vim.fn.filereadable(state_file) == 1 then
      local content = vim.fn.readfile(state_file)[1]
      vim.g.copilot_enabled = (content == '1') and 1 or 0
    else
      -- Default state if file doesn't exist (enabled)
      vim.g.copilot_enabled = 1
    end

    -- Save state function
    local function save_state()
      vim.fn.writefile({ vim.g.copilot_enabled == 1 and '1' or '0' }, state_file)
    end

    vim.g.copilot_no_tab_map = true
    vim.g.copilot_workspace_folders = { vim.fn.getcwd() }

    -- Accept suggestion mapping
    vim.keymap.set('i', '<C-enter>', 'copilot#Accept("\\<CR>")', {
      expr = true,
      replace_keycodes = false,
    })

    -- Toggle Copilot with persistent state
    vim.keymap.set('n', '<leader>ac', function()
      if vim.g.copilot_enabled == 1 then
        vim.g.copilot_enabled = 0
        vim.notify('Copilot disabled', vim.log.levels.INFO)
      else
        vim.g.copilot_enabled = 1
        vim.notify('Copilot enabled', vim.log.levels.INFO)
      end
      save_state() -- Save the new state
    end, { desc = 'Toggle Copilot' })

    -- Save state when leaving Neovim (safety measure)
    vim.api.nvim_create_autocmd('VimLeave', {
      callback = save_state,
    })
  end,
}
