-- opencode.nvim (agent bridge). Not an nvf module, so it's wired here.
-- NOTE: opencode.nvim's API moves quickly; if a mapping errors, check the
-- function names against the installed version's README.
local ok, opencode = pcall(require, "opencode")
if not ok then
  return
end

vim.g.opencode_opts = {}

local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

map("n", "<leader>oo", function()
  opencode.toggle()
end, "opencode: toggle")

map({ "n", "v" }, "<leader>oa", function()
  opencode.ask()
end, "opencode: ask")

map("n", "<leader>o+", function()
  opencode.prompt("@buffer ")
end, "opencode: add buffer to context")

map("v", "<leader>o+", function()
  opencode.prompt("@selection ")
end, "opencode: add selection to context")

map("n", "<leader>on", function()
  opencode.command("session_new")
end, "opencode: new session")
