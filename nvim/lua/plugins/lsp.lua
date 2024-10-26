-- init.lua
return {
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v3.x",
        dependencies = {
            "neovim/nvim-lspconfig",
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-vsnip",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "SirVer/ultisnips",
            "honza/vim-snippets",
        },
        config = function()
            local lsp = require("lsp-zero")
            lsp.preset("recommended")
            lsp.ensure_installed({})
            -- Fix Undefined global 'vim'
            lsp.nvim_workspace()
            -- Configure cmp
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
            -- LSP Preferences
            lsp.set_preferences({
                suggest_lsp_servers = false,
                sign_icons = {
                    error = "E",
                    warn = "W",
                    hint = "H",
                    info = "I",
                },
            })
            -- LSP Keymaps
            lsp.on_attach(function(client, bufnr)
                local opts = { buffer = bufnr, remap = false }
                vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
                vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
                vim.keymap.set("n", "<leader>dn", function() vim.diagnostic.goto_next() end, opts)
                vim.keymap.set("n", "<leader>df", function() vim.diagnostic.open_float() end, opts)
                vim.keymap.set("n", "<leader>dp", function() vim.diagnostic.goto_prev() end, opts)
                vim.keymap.set("n", "<leader>fc", function() vim.lsp.buf.rename() end, opts)
            end)
            -- LSP Setup
            lsp.setup({
                sources = {
                    { name = "nvim_lsp", keyword_length = 3 },
                    { name = "path" },
                    { name = "vsnip", keyword_length = 2 },
                    { name = "nvim_lsp_signature_help" },
                    { name = "nvim_lua", keyword_length = 2 },
                    { name = "buffer", keyword_length = 2 },
                    { name = "vim_snippets", keyword_length = 2 },
                    { name = "ultsisnips", keyword_length = 2 },
                },
            })
            -- Diagnostic Configuration
            vim.diagnostic.config({
                virtual_text = false,
                signs = true,
                underline = false,
                update_in_insert = false,
                severity_sort = false
            })
            -- Diagnostic Signs
            vim.diagnostic.config({
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = '❱❱',
                        [vim.diagnostic.severity.WARN] = '❱❱',
                        [vim.diagnostic.severity.HINT] = '❱❱',
                        [vim.diagnostic.severity.INFO] = '❱❱',
                    },
                },
            })
            -- Cosmetic Tweaks
            vim.fn.matchadd("ColorColumn", "\\%121v")
            vim.opt.completeopt = { "menuone", "noinsert", "noselect", "preview" }
            vim.opt.shortmess = vim.opt.shortmess + { c = true }
            -- File type configuration
            vim.filetype.add({
                extension = { templ = "templ" },
            })
        end
    }
}
