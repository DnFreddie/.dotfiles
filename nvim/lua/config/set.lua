vim.opt.nu = false
vim.opt.relativenumber = true
vim.opt.grepprg ="rg --vimgrep --no-heading --color=never --no-heading  --column --smart-case"
vim.opt.path:append("**")

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.smartindent = true
---vim.api.nvim_set_var('netrw_keepdir', 0)

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.diagnostic.config({
  virtual_text = false,   -- Disable inline diagnostic messages
  signs = true,           -- Show signs in the sign column
  underline = false,       -- Underline diagnostic issues
  update_in_insert = false, -- Only update diagnostics when leaving insert mode
  severity_sort = true,   -- Sort diagnostics by severity (optional)
})


-- Highlight on yank
vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	group = "YankHighlight",
	pattern = "*",
	callback = function()
		vim.highlight.on_yank{
			higroup = "Visual",
			timeout = 300,
		}
	end,
})
