local function run_on_visual()
    -- Save the current selection to register 'a'
    local saved_reg = vim.fn.getreg("a")
    vim.cmd('normal! gv"ay')

    -- Get the selected text
    local selected_text = vim.fn.getreg("a")

    -- Restore register 'a'
    vim.fn.setreg("a", saved_reg)

    -- Prompt for command with native shell-like completion
    local command = vim.fn.input("Command to run: ", "", "shellcmd")
    if command == "" then return end

    -- Run command with piped input
    local output = vim.fn.system(command .. " <<< " .. vim.fn.shellescape(selected_text))
    output = output:gsub("\n$", "") -- Remove trailing newline

    -- Replace the selection with the output
    vim.cmd('normal! gv"_c' .. vim.fn.escape(output, "\\|"))
end

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
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function() limit_oldfiles(7) end,
})

