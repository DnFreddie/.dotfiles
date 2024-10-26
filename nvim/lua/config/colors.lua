--------------------------------------------------------------------------------
-- Diagnostic Signs
--------------------------------------------------------------------------------

local signs = {
	DiagnosticSignError = "❱❱",
	DiagnosticSignWarn = "❱❱",
	DiagnosticSignHint = "❱❱",
	DiagnosticSignInfo = "❱❱",
}

for name, sign in pairs(signs) do
	vim.fn.sign_define(name, {
		texthl = name,
		text = sign,
	})
end

--------------------------------------------------------------------------------
-- Other Cosmetic Tweaks
--------------------------------------------------------------------------------

-- Highlight 121st character on lines that exceed 120
vim.fn.matchadd("ColorColumn", "\\%121v")
vim.diagnostic.config({
  virtual_text = false,   -- Disable inline diagnostic messages
  signs = true,           -- Show signs in the sign column
  underline = false,       -- Underline diagnostic issues
  update_in_insert = false, -- Only update diagnostics when leaving insert mode
  severity_sort = true,   -- Sort diagnostics by severity (optional)
})



-- Highlight briefly on yank
