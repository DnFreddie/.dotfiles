vim.g.mapleader = " "

--swaping
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
--jumping
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
-- next greatest remap ever : asbjornHaland
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
-- scroll back one page by ctrl space 
vim.keymap.set("n", "<C-Space>", "<C-f>")
-- scroll back one page by ctrl shtift  space  
--vim.keymap.set("n", "<C-S-Space>", "<C-u>")
--vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])
--vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])


vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
--vim.keymap.set("n", "<leader>o","<cmd>find ~/<Cr>")
vim.keymap.set("n", "<leader>o", "<cmd>execute 'tcd ' . fnameescape(expand('%:h'))<CR>")
vim.keymap.set("n", "<leader><space>", ":Explore<CR>")
vim.api.nvim_exec([[
function! ReplaceHighlightedText()
    " Get the start and end position of the visual selection
    let start_pos = getpos("'<")
    let end_pos = getpos("'>")
    " Capture the highlighted text
    let l:pattern = getline(start_pos[1])[start_pos[2]-1:end_pos[2]-1]
    " Check if the pattern is not empty
    if !empty(l:pattern)
        " Escape special characters in the yanked text
        let l:pattern_escaped = escape(l:pattern, '/\')
        " Clear the last search highlight
        let @/ = ""
        " Prompt for replacement text
        let l:replacement = input('Enter replacement text: ')
        " Escape special characters in the replacement text
        let l:replacement_escaped = escape(l:replacement, '/\&')
        " Replace globally in the file
        execute '%s/' . l:pattern_escaped . '/' . l:replacement_escaped . '/g'
    else
        echo "No text was selected for replacement."
    endif
endfunction

xnoremap <leader>ff :<C-u>call ReplaceHighlightedText()<CR>
]], false)

-- vim.keymap.set("i", "<CR>", function()
--   if vim.fn["coc#pum#visible"]() then
--     return vim.fn["coc#_select_confirm"]()
--   else
--     return vim.api.nvim_replace_termcodes("<CR>", true, true, true)
--   end
-- end, { silent = true, expr = true })

-- -- Some servers have issues with backup files, see #649
-- vim.opt.backup = false
-- vim.opt.writebackup = false

-- -- Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
-- -- delays and poor user experience
vim.opt.updatetime = 300

-- -- Always show the signcolumn, otherwise it would shift the text each time
-- -- diagnostics appeared/became resolved
vim.opt.signcolumn = "yes"
vim.api.nvim_set_keymap('n', '<C-w>f', ':tab split<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-w>F', ':tabc<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<Leader>n', 'eif err !== nil { }<Esc>', {noremap = true})




-- local keyset = vim.keymap.set
-- -- v
-- function _G.check_back_space()
--     local col = vim.fn.col('.') - 1
--     return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
-- end

-- -- Use Tab for trigger completion with characters ahead and navigate
-- -- NOTE: There's always a completion item selected by default, you may want to enable
-- -- no select by setting `"suggest.noselect": true` in your configuration file
-- -- NOTE: Use command ':verbose imap <tab>' to make sure Tab is not mapped by
-- -- other plugins before putting this into your config
-- local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
-- keyset("i", "<S-TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
-- keyset("i", "<C-y>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

-- -- Make <CR> to accept selected completion item or notify coc.nvim to format
-- -- <C-g>u breaks current undo, please make your own choice
-- keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

-- -- Use <c-j> to trigger snippets
-- keyset("i", "<c-j>", "<Plug>(coc-snippets-expand-jump)")
-- -- Use <c-space> to trigger completion
-- keyset("i", "<c-space>", "coc#refresh()", {silent = true, expr = true})


