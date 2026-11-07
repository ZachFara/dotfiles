-- print("Hello from init.lua in the xed directory")

-- Always configure plugins first so that other modules can safely require them.
require("xed/packer")
require("xed/remaps")
require("xed/lsp")
