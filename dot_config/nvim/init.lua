vim.g.mapleader = " "

-- print("Hello from init.lua")

require("xed")

vim.opt.termguicolors = true

-- Themes and colors
vim.cmd("colorscheme onedark")

-- Tab options
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Line number stuff
vim.opt.number = true
vim.opt.relativenumber = true
