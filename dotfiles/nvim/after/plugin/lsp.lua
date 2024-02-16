local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
  'rust_analyzer',
})

-- Fix Undefined global 'vim'
lsp.nvim_workspace()



local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-x>'] = cmp.mapping.select_next_item(cmp_select),
  ['<C-e>'] = cmp.mapping.confirm({ select = true }),
["<C-d>"] = cmp.mapping.complete(),
})
cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil
lsp.setup_nvim_cmp({
  mapping = cmp_mappings
})

lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})

lsp.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}

  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  --vim.keymap.set("i", "<C-g>", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.setup({
    sources = {
        { name = 'nvim_lsp',keyword_length = 3 },
        { name = 'path' },
        { name = 'vsnip',keyword_length = 2 },
        { name = 'nvim_lsp_signature_help' },
        { name = 'nvim_lua'  ,keyword_length = 2 } ,
        { name = 'buffer',keyword_length = 2  },
        { name = 'vim_snippets',keyword_length = 2  },
        { name = 'ultsisnips',keyword_length = 2  },
    }
})

vim.diagnostic.config({
    virtual_text = true
})
vim.opt.completeopt  = { "menuone", "noinsert", "noselect" ,"preview"}
vim.opt.shortmess =  vim.opt.shortmess + { c = true }
