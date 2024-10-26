local lsp = require("lsp-zero")
lsp.preset("recommended")
lsp.ensure_installed({})
lsp.nvim_workspace()

-- Configure diagnostic preferences early
lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = "E",
        warn = "W",
        hint = "H",
        info = "I",
    },
    diagnostic_config = {
        virtual_text = false,
        signs = true,
        update_in_insert = false,
        underline = true,
        severity_sort = true,
    }
})

-- CMP configuration
local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
    ["<C-x>"] = cmp.mapping.select_next_item(cmp_select),
    ["<C-e>"] = cmp.mapping.confirm({ select = true }),
    ["<C-d>"] = cmp.mapping.complete(),
})
cmp_mappings["<Tab>"] = nil
cmp_mappings["<S-Tab>"] = nil

lsp.setup_nvim_cmp({
    mapping = cmp_mappings,
    completion = {
        autocomplete = false
    }
})

-- LSP attach configuration
lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }
    -- Keymaps
    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "<leader>dn", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "<leader>dp", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>df", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "<leader>fc", function() vim.lsp.buf.rename() end, opts)

    -- Ensure diagnostic config is applied after LSP attaches
    vim.diagnostic.config({
        virtual_text = false,
        signs = true,
        update_in_insert = false,
        underline = true,
        severity_sort = true,
    })
end)

-- Main LSP setup
lsp.setup({
    sources = {
        { name = "nvim_lsp", keyword_length = 3 },
        { name = "path" },
        { name = "vsnip", keyword_length = 2 },
        { name = "nvim_lsp_signature_help" },
        { name = "nvim_lua", keyword_length = 2 },
        { name = "buffer", keyword_length = 2 },
        { name = "vim_snippets", keyword_length = 2 },
        { name = "ultsisnips", keyword_length = 2 }
    },
    diagnostics = {
        virtual_text = false,
        signs = true,
        update_in_insert = false,
        underline = true,
        severity_sort = true,
    }
})

-- Force diagnostic config with autocmd as fallback
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function()
        vim.diagnostic.config({
            virtual_text = false,
            signs = true,
            update_in_insert = false,
            underline = true,
            severity_sort = true,
        })
    end,
})

-- Additional Neovim options
vim.opt.completeopt = { "menuone", "noinsert", "noselect", "preview" }
vim.opt.shortmess = vim.opt.shortmess + { c = false }

-- Filetype configuration
vim.filetype.add({
    extension = { templ = "templ" },
})
