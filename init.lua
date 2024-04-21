vim.g.have_nerd_font = true


-- [[ Install mini.nvim ]]
local path_package = vim.fn.stdpath('data') .. '/site'
local mini_path = path_package .. '/pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    -- Uncomment next line to use 'stable' branch
    -- '--branch', 'stable',
    'https://github.com/echasnovski/mini.nvim', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require('mini.deps').setup({ path = { package = path_package } })
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later


-- [[ UI ]]

-- Colorscheme
now(function()
  vim.o.termguicolors = true
  vim.cmd('colorscheme randomhue')
end)

-- Prettier notification
now(function()
  require('mini.notify').setup()
  vim.notify = require('mini.notify').make_notify()
end)

-- Tabline & Statusline
now(function()
  require('mini.tabline').setup({
    show_icons = vim.g.have_nerd_font
  })
end)
now(function()
  require('mini.statusline').setup({
    use_icons = vim.g.have_nerd_font
  })
end)

-- Startup dashboard
now(function() require('mini.starter').setup() end)

-- Animated indentation guide
later(function()
  require('mini.indentscope').setup()
end)

later(function()
local miniclue = require('mini.clue')
miniclue.setup({
  triggers = {
    -- Leader triggers
    { mode = 'n', keys = '<Leader>' },
    { mode = 'x', keys = '<Leader>' },

    -- Built-in completion
    { mode = 'i', keys = '<C-x>' },

    -- `g` key
    { mode = 'n', keys = 'g' },
    { mode = 'x', keys = 'g' },

    -- Marks
    { mode = 'n', keys = "'" },
    { mode = 'n', keys = '`' },
    { mode = 'x', keys = "'" },
    { mode = 'x', keys = '`' },

    -- Registers
    { mode = 'n', keys = '"' },
    { mode = 'x', keys = '"' },
    { mode = 'i', keys = '<C-r>' },
    { mode = 'c', keys = '<C-r>' },

    -- Window commands
    { mode = 'n', keys = '<C-w>' },

    -- `z` key
    { mode = 'n', keys = 'z' },
    { mode = 'x', keys = 'z' },
  },

  clues = {
    -- Enhance this by adding descriptions for <Leader> mapping groups
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),

    -- document existing key chains
    { mode = 'n', keys = '<Leader>c', desc = '+[C]ode' },
    { mode = 'n', keys = '<Leader>d', desc = '+[D]ocument' },
    { mode = 'n', keys = '<Leader>g', desc = '+[G]it' },
    { mode = 'n', keys = '<Leader>h', desc = '+More [G]it' },
    { mode = 'n', keys = '<Leader>r', desc = '+[R]ename' },
    { mode = 'n', keys = '<Leader>s', desc = '+[S]earch' },
    { mode = 'n', keys = '<Leader>w', desc = '+[W]orkspace' },
  },
})
end)


-- [[ Editing Experience ]]

-- Sensible default options and keymaps
now(function()
  require('mini.basics').setup({
    options = {
      basic = true,
      extra_ui = true,
      win_borders = 'single',
    },
    mappings = {
      basic = true,
      -- Prefix for mappings that toggle common options ('wrap', 'spell', ...).
      -- Supply empty string to not create these mappings.
      option_toggle_prefix = [[\]],
      -- Window navigation with <C-hjkl>, resize with <C-arrow>
      windows = true,
      -- Move cursor in Insert, Command, and Terminal mode with <M-hjkl>
      move_with_alt = false,
    },
    autocommands = {
      -- Basic autocommands (highlight on yank, start Insert in terminal, ...)
      basic = true,
      -- Set 'relativenumber' only in linewise and blockwise Visual mode
      relnum_in_visual_mode = true,
    },
    -- Whether to disable showing non-error feedback
    silent = false,
  })
end)

-- Completion
later(function()
  require('mini.completion').setup()
end)
vim.keymap.set('i', '<Tab>',   [[pumvisible() ? "\<C-n>" : "\<Tab>"]],   { expr = true })
vim.keymap.set('i', '<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true })

-- Better Around/Inside textobjects
--
-- Examples:
--  - va)  - [V]isually select [A]round [)]paren
--  - yinq - [Y]ank [I]nside [N]ext [']quote
--  - ci'  - [C]hange [I]nside [']quote
later(function() require('mini.ai').setup({ n_lines = 500 }) end)

-- 'gc' to toggle comment
later(function() require('mini.comment').setup() end)


-- [[ Picker ]]

later(function()
  require('mini.pick').setup()
  vim.keymap.set('n', '<leader>sh', MiniPick.builtin.help, { desc = '[S]earch [H]elp' })
  vim.keymap.set('n', '<leader>sf', MiniPick.builtin.files, { desc = '[S]earch [F]iles' })
  vim.keymap.set('n', '<leader>sg', MiniPick.builtin.grep_live, { desc = '[S]earch by [G]rep' })
  vim.keymap.set('n', '<leader>sr', MiniPick.builtin.resume, { desc = '[S]earch [R]esume' })
  vim.keymap.set('n', '<leader><leader>', MiniPick.builtin.buffers, { desc = '[ ] Find existing buffers' })
end)

