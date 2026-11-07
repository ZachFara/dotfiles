local ok, oil = pcall(require, "oil")
if not ok then
  vim.notify("[xed] oil.nvim not available", vim.log.levels.WARN)
  return
end

oil.setup({
  default_file_explorer = false, -- keep netrw available if needed
  columns = { "icon" },
  view_options = {
    show_hidden = true,
  },
})

vim.keymap.set("n", "<leader>o", function()
  oil.open()
end, { desc = "Open oil file explorer" })
