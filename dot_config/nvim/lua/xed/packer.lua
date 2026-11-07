local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd('packadd packer.nvim')
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

local ok, packer = pcall(require, 'packer')
if not ok then
  vim.notify('packer.nvim is not available', vim.log.levels.ERROR)
  return
end

return packer.startup(function(use)
  use 'wbthomason/packer.nvim'
  use {
	  "williamboman/mason.nvim",
	  "williamboman/mason-lspconfig.nvim",
	  "neovim/nvim-lspconfig",
  }
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'L3MON4D3/LuaSnip'

  --packages to add: tree-sitter, harpoon, undotree, vim-fugitive

  use { "nvim-telescope/telescope.nvim", tag = '0.1.4', requires = { 'nvim-lua/plenary.nvim' }}

  -- Color Schemes
  -- Rose Pine
  -- use { "rose-pine/neovim", name = "rose-pine" }
  -- colorscheme rose-pine

  -- One Dark for nvim
  use 'navarasu/onedark.nvim'

  -- treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate', -- Automatically update parsers
  }

  -- Harpoon (Project Navigation)
  use 'ThePrimeagen/harpoon'
  use 'christoomey/vim-tmux-navigator'

  -- UndoTree (Visual Undo History)
  use 'mbbill/undotree'

  -- Vim-fugitive (Git Integration)
  use 'tpope/vim-fugitive'

  -- File explorer replacement
  use {
    'stevearc/oil.nvim',
    requires = { 'nvim-tree/nvim-web-devicons' },
  }

  -- Flash navigation
  use 'folke/flash.nvim'

  -- Surround editing
  use 'echasnovski/mini.surround'

  -- nvim autopairs
  use {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      config = function()
          require("nvim-autopairs").setup {}
      end
  }

  if packer_bootstrap then
    packer.sync()
  end
end)
