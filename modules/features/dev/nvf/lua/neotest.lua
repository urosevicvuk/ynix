-- neotest (test runner). Not an nvf module; installed as startPlugins in
-- lsp.nix and configured here with the adapters that are available.
local ok, neotest = pcall(require, "neotest")
if not ok then
  return
end

local adapters = {}
for _, name in ipairs({ "neotest-go", "neotest-python", "neotest-rust" }) do
  local aok, adapter = pcall(require, name)
  if aok then
    table.insert(adapters, adapter)
  end
end

neotest.setup({ adapters = adapters })

local function map(lhs, rhs, desc)
  vim.keymap.set("n", lhs, rhs, { silent = true, desc = desc })
end

map("<leader>tt", function()
  neotest.run.run()
end, "Test nearest")

map("<leader>tf", function()
  neotest.run.run(vim.fn.expand("%"))
end, "Test file")

map("<leader>tS", function()
  neotest.run.stop()
end, "Test stop")

map("<leader>ts", function()
  neotest.summary.toggle()
end, "Test summary")

map("<leader>to", function()
  neotest.output.open({ enter = true })
end, "Test output")
