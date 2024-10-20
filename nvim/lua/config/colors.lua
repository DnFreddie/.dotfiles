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


-- Highlight briefly on yank