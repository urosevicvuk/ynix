-- Single-color (gray) rainbow delimiters instead of the default multi-color.
local ok, rainbow_delimiters = pcall(require, "rainbow-delimiters")
if not ok then
  return
end

vim.g.rainbow_delimiters = {
  strategy = { [""] = rainbow_delimiters.strategy["global"] },
  query = { [""] = "rainbow-delimiters" },
  highlight = { "RainbowDelimiterGray" },
}
vim.api.nvim_set_hl(0, "RainbowDelimiterGray", { fg = "#928374" })
