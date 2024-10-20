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

