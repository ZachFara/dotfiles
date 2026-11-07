local ok, mini_surround = pcall(require, "mini.surround")
if not ok then
  vim.notify("[xed] mini.surround not available", vim.log.levels.WARN)
  return
end

mini_surround.setup({
  custom_surroundings = {
    ["("] = { output = { left = "(", right = ")" } },
    [")"] = { output = { left = "(", right = ")" } },
    ["{"] = { output = { left = "{", right = "}" } },
    ["}"] = { output = { left = "{", right = "}" } },
    ["["] = { output = { left = "[", right = "]" } },
    ["]"] = { output = { left = "[", right = "]" } },
    ["<"] = { output = { left = "<", right = ">" } },
    [">"] = { output = { left = "<", right = ">" } },
  },
})
