# Custom Keymaps & Aliases

All shortcuts currently defined in this Neovim config, grouped by the file that sets them. Mode legends: `n` = normal, `v` = visual, `i` = insert. Leader is `<Space>`.

## `lua/xed/remaps.lua`
- `<leader>pv` (n) → `:Ex<CR>` — open the built-in netrw explorer.

## `after/plugin/oil.lua`
- `<leader>o` (n) → `oil.open()` — open the Oil buffer explorer on demand.

## `after/plugin/flash.lua`
- `<leader>z` (n/x/o) → `flash.jump()` — fuzzy jump to visible text.
- `<leader>Z` (n/x/o) → `flash.treesitter()` — jump by Treesitter nodes.
- `<leader>zr` (o) → `flash.remote()` — operate on remote targets in operator-pending mode.
- `<leader>zR` (o/x) → `flash.treesitter_search()` — select regions via Treesitter search.
- `<C-s>` (command-line) → `flash.toggle()` — enable/disable Flash-enhanced search.

## `after/plugin/mini_surround.lua`
- Uses MiniSurround defaults: `sa` add surroundings, `sd` delete, `sr` replace, etc.
- `<leader>pt` (n) → `:terminal<CR>` — drop into an embedded terminal.
- `<leader>nh` (n) → `:noh<CR>` — clear search highlights.
- `<leader>rg` (n) → `:Telescope registers<CR>` — fuzzy-pick from Vim registers.
- `{`, `}`, `[[`, `]]`, `<C-d>`, `<C-u>`, `<C-f>`, `<C-b>`, `H`, `M`, `L`, `n`, `N` (n) → respective motions followed by `zz` — keep the cursor centered while navigating.
- `cy` (v/n) → `"+y`/`"+yy` — yank to the system clipboard.
- `cp` (v/n) → `"+p` — paste from the system clipboard.
- `<leader>s` (n) → `:source %<CR>` — reload the current file.
- `<leader>w` / `<leader>q` / `<leader>pq` / `<leader>Q` (n) → `:write`, `:quit`, `:write | quit`, `:q!` — save/quit helpers.
- `<leader>k` (n) → `vim.lsp.buf.hover()` — LSP hover lookup without reaching for `K`.
- `<leader>ga` (n) → `ggVG` — select the entire buffer.

## `lua/xed/lsp.lua` (per-buffer once LSP attaches)
- `K` (n) → `vim.lsp.buf.hover()` — show documentation for symbol under cursor.
- `gd` (n) → `vim.lsp.buf.definition()` — jump to definition.
- `gr` (n) → `vim.lsp.buf.references()` — list references.
- `<leader>rn` (n) → `vim.lsp.buf.rename()` — rename symbol.

## `after/plugin/telescope.lua`
- `<leader>pf` (n) → `builtin.find_files` — Telescope file search.
- `<C-p>` (n) → `builtin.git_files` — search tracked files.
- `<leader>ps` (n) → `builtin.grep_string` with prompt input — live grep prompt.

## `after/plugin/harpoon.lua`
- `<leader>a` (n) → `harpoon.mark.add_file` — add current file to Harpoon list.
- `<C-e>` (n) → `harpoon.ui.toggle_quick_menu` — open Harpoon menu.
- `<leader>1`, `<leader>2`, `<leader>3`, `<leader>4` (n) → `harpoon.ui.nav_file(1-4)` — jump to the nth Harpoon slot.

## `after/plugin/fugitive.lua`
- `<leader>gs` (n) → `:Git` — open Fugitive status.
- `<leader>gA` (n) → `:Git add .` — stage everything.
- `<leader>gc` (n) → `:Git commit` — start a commit.
- `<leader>gp` (n) → `:Git push`
- `<leader>gP` (n) → `:Git pull`
- `<leader>gb` (n) → `:Git branch`

## `after/plugin/undotree.lua`
- `<leader>u` (n) → `:UndotreeToggle` — open/close UndoTree panel.

These cover every `vim.api.nvim_set_keymap`/`vim.keymap.set` invocation in the repo, so you’ve got a single place to review or tweak shortcuts you’ve customized.
