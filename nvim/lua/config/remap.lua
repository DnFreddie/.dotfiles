vim.g.mapleader = " "

--swaping
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
--jumping
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>dd", [["+dd]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
-- scroll back one page by ctrl space
vim.keymap.set("n", "<C-Space>", "<C-f>")
-- scroll back one page by ctrl shtift  space
--vim.keymap.set("n", "<C-S-Space>", "<C-u>")
--vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])
--vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set(
	"n",
	"<leader>s",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]
)
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
--vim.keymap.set("n", "<leader>o","<cmd>find ~/<Cr>")
vim.keymap.set(
	"n",
	"<leader>o",
	"<cmd>execute 'tcd ' . fnameescape(expand('%:h'))<CR>"
)
vim.keymap.set("n", "<leader><space>", ":Explore<CR>")
---vim.keymap.set("n", "<leader>fr", ":bro ol <CR>")
--
-- -- Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
-- -- delays and poor user experience
vim.opt.updatetime = 300

-- -- Always show the signcolumn, otherwise it would shift the text each time
-- -- diagnostics appeared/became resolved
vim.opt.signcolumn = "yes"
vim.api.nvim_set_keymap("n", "<C-w>f", ":tab split<CR>", {
	noremap = true,
	silent = true,
})
vim.api.nvim_set_keymap("n", "<C-w>F", ":tabc<CR>", {
	noremap = true,
	silent = true,
})
vim.opt.wildmenu = true
vim.opt.wildmode = "full:lastused"
--vim.api.nvim_set_keymap('n', '<C-p>', ' mzyyP`z', { noremap = true, silent = true })

local function duplicate_line_and_move_down()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local row, col = cursor[1], cursor[2]

	local line = vim.api.nvim_get_current_line()

	vim.api.nvim_buf_set_lines(0, row, row, false, { line })

	vim.api.nvim_win_set_cursor(0, { row + 1, col })
end

-- Set the keymap to call the function with Ctrl+P
vim.api.nvim_set_keymap("n", "<C-p>", "", {
	noremap = true,
	silent = true,
	callback = duplicate_line_and_move_down,
})

vim.api.nvim_set_keymap("n", "<Leader>cc", ": belowright Compile<CR>", {
	noremap = true,
	silent = true,
})
vim.api.nvim_set_keymap("n", "<Leader>cr", ": belowright Recompile<CR>", {
	noremap = true,
	silent = true,
})
vim.api.nvim_set_keymap(
	"n",
	"<Leader>cq",
	':windo if &buftype == "quickfix" || bufname("%") =~ "compilation" | close | endif<CR>',
	{
		noremap = true,
		silent = true,
	}
)
vim.api.nvim_set_keymap("n", "<Leader>cn", ": NextError<CR>", {
	noremap = true,
	silent = true,
})
vim.api.nvim_set_keymap("n", "<Leader>cp", ": :PrevError<CR>", {
	noremap = true,
	silent = true,
})

vim.keymap.set("n", "<leader>gt", vim.cmd.GoTest)
vim.keymap.set("n", "<leader>ge", vim.cmd.GoIfErr)
vim.keymap.set("n", "<leader>gf", vim.cmd.GoFillStruckt)
vim.keymap.set("n", "<leader>gt", vim.cmd.GoAddTag)
