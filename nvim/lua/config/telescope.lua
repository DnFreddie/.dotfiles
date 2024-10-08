local builtin = require('telescope.builtin')
require('telescope').setup {
  defaults = {
    previewer = false,  -- This disables the previewer for all pickers
    file_ignore_patterns = {"node_modules", "static"},
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
    },
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
    -- Enable color highlighting for matches
    color_devicons = true,
    -- Highlight matching parts of results
    winblend = 0,
  },
  pickers = {
    find_files = {
      theme = "ivy",
      layout_config = {
        height = 0.3,
      },
    },
    live_grep = {
      theme = "ivy",
      layout_config = {
        height = 0.3,
      },
    },
    grep_string = {
      theme = "ivy",
      layout_config = {
        height = 0.3,
      },
    },
    current_buffer_fuzzy_find = {
      theme = "ivy",
      previewer = false,
      layout_config = {
        height = 0.3,
      },
    },
    diagnostics = {
      theme = "ivy",
      layout_config = {
        height = 0.3,
      },
    },
    oldfiles = {
      theme = "ivy",
      previewer = false,
      layout_config = {
        height = 0.3,
      },
    },

    lsp_references = {
      theme = "ivy",
      previewer = false,
      layout_config = {
        height = 0.3,
      },
    },

    lsp_dynamic_workspace_symbols = {
      theme = "ivy",
      previewer = true,
      layout_config = {
        height = 0.3,
      },
    },

    lsp_document_symbols = {
      theme = "ivy",
      previewer = true,
      layout_config = {
        height = 0.3,
      },
    },

    buffers = {
      theme = "ivy",
      previewer = true,
      layout_config = {
        height = 0.3,
      },
    },


  },
}

pcall(require('telescope').load_extension, 'fzf')

-- Key mappings
vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = '[ ] Find existing buffers' })

vim.keymap.set('n', '<leader>/', builtin.current_buffer_fuzzy_find, { desc = '[S]earch by Fuzzily buffer' })

vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>e', function() builtin.find_files({previewer = false}) end, {})
vim.keymap.set('n', '<leader>fg', function() builtin.live_grep({previewer = false}) end, {})
vim.keymap.set('n', '<leader>fr', function() builtin.oldfiles({ previewer = false }) end, { desc = '[?] Find recently opened files' })
-- lsp 
vim.keymap.set('n', '<leader>ff', function() builtin.lsp_references({ previewer = false }) end, { desc = '[?] Find Refrences' })
vim.keymap.set('n', '<leader>fs', function() builtin.lsp_document_symbols({ previewer = false }) end, { desc = '[?] Find Document Symlos' })
vim.keymap.set('n', '<leader>fa', function() builtin.lsp_dynamic_workspace_symbols	({ previewer = false }) end, { desc = '[?] Find Document Symlos' })
vim.keymap.set('n', '<leader>fi', function() builtin.lsp_implementations({ previewer = false }) end, { desc = '[?] Find Document Symlos' })

-- Highlight customization for search matches
vim.cmd([[
  highlight TelescopeResultsFilename guifg=#880808 gui=bold  " Set filenames to blue
  highlight TelescopeResultsBorder guifg=#565f89              " Set the border color
  highlight TelescopePromptBorder guifg=#565f89              " Set the prompt border color
  highlight TelescopeSelection guibg=#3E4451 guifg=#FFFFFF    " Selected result's background color and text (white on dark grey)
  highlight TelescopeMatching guifg=#E5C07B gui=bold          " Matched characters in search results (yellow)
]])
