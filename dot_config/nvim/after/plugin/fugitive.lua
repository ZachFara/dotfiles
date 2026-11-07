-- after/plugin/fugitive.lua

-- Remaps
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>gs", ":Git<CR>", opts)
vim.keymap.set("n", "<leader>gA", ":Git add .<CR>", opts)
vim.keymap.set("n", "<leader>gc", ":Git commit<CR>", opts)
vim.keymap.set("n", "<leader>gp", ":Git push<CR>", opts)
vim.keymap.set("n", "<leader>gP", ":Git pull<CR>", opts)
vim.keymap.set("n", "<leader>gb", ":Git branch<CR>", opts)

