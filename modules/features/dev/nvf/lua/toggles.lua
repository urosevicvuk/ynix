-- UI toggles via Snacks.toggle: state-aware and shown in which-key.
-- (Replaces the old <leader>u set!-style keymaps.)
local ok, Snacks = pcall(require, "snacks")
if not ok then
  return
end

local toggle = Snacks.toggle

toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
toggle.option("linebreak", { name = "Linebreak" }):map("<leader>ul")
toggle.option("spell", { name = "Spelling" }):map("<leader>us")
toggle.option("cursorline", { name = "Cursorline" }):map("<leader>uc")
toggle.line_number():map("<leader>un")
toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>ur")
toggle.diagnostics():map("<leader>ud")
toggle.inlay_hints():map("<leader>uh")
toggle.treesitter():map("<leader>uT")

-- Tabline has no snacks preset; small custom toggle.
toggle
  .new({
    name = "Tabline",
    get = function()
      return vim.o.showtabline == 2
    end,
    set = function(state)
      vim.o.showtabline = state and 2 or 0
    end,
  })
  :map("<leader>ut")
