local ok, flash = pcall(require, "flash")
if not ok then
  vim.notify("[xed] flash.nvim not available", vim.log.levels.WARN)
  return
end

flash.setup()

vim.keymap.set({ "n", "x", "o" }, "<leader>z", function()
  flash.jump()
end, { desc = "Flash jump" })

vim.keymap.set({ "n", "x", "o" }, "<leader>Z", function()
  flash.treesitter()
end, { desc = "Flash treesitter" })

vim.keymap.set("o", "<leader>zr", function()
  flash.remote()
end, { desc = "Flash remote" })

vim.keymap.set({ "o", "x" }, "<leader>zR", function()
  flash.treesitter_search()
end, { desc = "Flash TS search" })

vim.keymap.set({ "c" }, "<c-s>", function()
  flash.toggle()
end, { desc = "Toggle Flash search" })
