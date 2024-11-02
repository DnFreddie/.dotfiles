local function run_on_visual()

	vim.cmd('normal! gv"ay')
	local text = vim.fn.getreg("a")

	local cmd = vim.fn.input("Command: ")
	if cmd == "" then return end

	local output = vim.fn.system(cmd, text)
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_err_writeln("Command failed: " .. output)
		return
	end

	output = output:gsub("\n$", "")

	local escaped_output = vim.fn.escape(output, [[\]])
	vim.cmd("normal! gv")
	vim.cmd(string.format("normal! c%s", escaped_output))
end

vim.api.nvim_create_user_command(
	"RunOnVisual",
	function()
		run_on_visual()
	end,
	{ range = true }
)

vim.api.nvim_create_user_command(
	"RunOnVisual",
	function()
		run_on_visual()
	end,
	{ range = true }
)

vim.api.nvim_create_user_command(
	"RunOnVisual",
	function()
		run_on_visual()
	end,
	{ range = true }
)

vim.api.nvim_create_user_command(
	"RunOnVisual",
	function()
		run_on_visual()
	end,
	{ range = true }
)

vim.keymap.set("x", "f", run_on_visual)

-- Lua: Truncate v:oldfiles to keep only the most recent N entries
local function limit_oldfiles(max_length)
	local oldfiles = vim.v.oldfiles
	if #oldfiles > max_length then
		-- Trim down to the last 'max_length' entries
		vim.v.oldfiles = { unpack(oldfiles, 1, max_length) }
	end
end

-- Set the limit to, say, 50 oldfiles
vim.api.nvim_create_autocmd("VimEnter", { callback = function()
	limit_oldfiles(7)
end })

vim.api.nvim_create_user_command(
	"GlobalMarkBasenames",
	function()
		local marks = vim.fn.getmarklist()
		local found_marks = false
		table.sort(marks, function(a, b)
			return a.mark:sub(2) < b.mark:sub(2)
		end)
		for _, mark in ipairs(marks) do
			local letter = mark.mark:sub(2, 2)
			if letter:match("[A-Z]") then
				found_marks = true
				local basename = vim.fn.fnamemodify(mark.file, ":t")
				local pos = mark.pos[2] .. ":" .. mark.pos[1] -- line:column format
				vim.api.nvim_echo(
					{
						{ "[" .. letter .. "] ", "Identifier" },
						{ basename, "Directory" },
						{ " (" .. pos .. ")", "Comment" },
						{ "\n", "NONE" },
					},
					false,
					{}
				)
			end
		end
		if not found_marks then
			vim.api.nvim_echo(
				{ { "No global marks found", "WarningMsg" } },
				false,
				{}
			)
		end
	end,
	{ desc = "Display basenames of files with global marks" }
)
vim.api.nvim_set_keymap("n", "<C-f>", ":GlobalMarkBasenames<CR>", {
	noremap = true,
	silent = true,
})
