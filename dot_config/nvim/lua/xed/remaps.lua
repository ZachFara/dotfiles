-- print("Hello from remaps.lua")

-- Set leader key to space

local opts = { noremap = true, silent = true }


-- File explorers
vim.api.nvim_set_keymap('n', '<leader>pv', ':Ex<CR>', opts)

-- Terminal remap
vim.api.nvim_set_keymap('n', '<leader>pt', ':terminal<CR>', opts)

-- Stop highlighting with a keymapping
vim.api.nvim_set_keymap('n', '<leader>nh', ':noh<CR>', opts)

-- Set a command to access my registers
vim.api.nvim_set_keymap('n', '<leader>rg', ':Telescope registers<CR>', opts)

-- Set some options for centering on horizontal movements
vim.api.nvim_set_keymap('n', '{', '{zz', opts)
vim.api.nvim_set_keymap('n', '}', '}zz', opts)
vim.api.nvim_set_keymap('n', '[[', '[[zz', opts)
vim.api.nvim_set_keymap('n', ']]', ']]zz', opts)

vim.api.nvim_set_keymap('n', '<C-d>', '<C-d>zz', opts)
vim.api.nvim_set_keymap('n', '<C-u>', '<C-u>zz', opts)
vim.api.nvim_set_keymap('n', '<C-f>', '<C-f>zz', opts) vim.api.nvim_set_keymap('n', '<C-b>', '<C-b>zz', opts)

vim.api.nvim_set_keymap('n', 'H', 'Hzz', opts)
vim.api.nvim_set_keymap('n', 'M', 'Mzz', opts)
vim.api.nvim_set_keymap('n', 'L', 'Lzz', opts)

vim.api.nvim_set_keymap('n', 'n', 'nzz', opts)
vim.api.nvim_set_keymap('n', 'N', 'Nzz', opts)

-- Remaps for quitting, copying to computer clipboard
vim.api.nvim_set_keymap('v', 'cy', '"+y', opts)
vim.api.nvim_set_keymap('n', 'cy', '"+yy', opts)

-- Remap for pasting from the system clipboard
vim.api.nvim_set_keymap('v', 'cp', '"+p', opts)
vim.api.nvim_set_keymap('n', 'cp', '"+p', opts)

-- Source the current file
vim.keymap.set('n', '<leader>s', ':source %<CR>', { noremap = true, silent = true })

-- Write (save) the current file
vim.keymap.set('n', '<leader>w', ':write<CR>', { noremap = true, silent = true })

-- Quit the current window
vim.keymap.set('n', '<leader>q', ':quit<CR>', { noremap = true, silent = true })

-- Write and quit
vim.keymap.set('n', '<leader>pq', ':write | quit<CR>', { noremap = true, silent = true })

-- Force quit without savingremaps
vim.keymap.set('n', '<leader>Q', ':q!<CR>', { noremap = true, silent = true })

-- Look up the documentation for the current highlighted thing
vim.api.nvim_set_keymap('n', '<leader>k', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })

-- Highlight the entire page
vim.api.nvim_set_keymap('n', '<leader>ga','ggVG', opts)
