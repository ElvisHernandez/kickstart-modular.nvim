-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<leader>ex', vim.cmd.Ex)

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- fugitive remaps
vim.keymap.set('n', '<leader>go', '<cmd>diffget //2<cr>', { desc = 'Get the --ours git changes' })
vim.keymap.set('n', '<leader>gt', '<cmd>diffget //3<cr>', { desc = 'Get the --theirs git changes' })

vim.keymap.set('n', '<leader>rc', ':vsplit ~/.config/nvim/init.lua<CR>', { desc = 'Open init.lua in new split' })
vim.keymap.set('n', '<leader>gd', ':lua vim.diagnostic.open_float()<CR>', { desc = 'Open tooltip with diagnostic on current line' })
-- vim.diagnostic.open_float()
-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Neotree remaps
vim.keymap.set('n', '<leader>ft', ':Neotree toggle=true<CR>', { desc = 'Toggle Neotree file tree' })
vim.keymap.set('n', '<leader>rt', ':Neotree reveal<cr>', { desc = 'Reveal the current file in the file tree' })

-- Go to previous and next buffers
vim.keymap.set('n', '<leader>pb', ':bprev<cr>', { desc = 'Go to previous buffer' })
vim.keymap.set('n', '<leader>nb', ':bnext<cr>', { desc = 'Go to next buffer' })

-- Swap open buffers
vim.keymap.set('n', '<leader>rr', '<c-w>r', { desc = 'Rotate open buffers counter-clockwise (I think??)' })
