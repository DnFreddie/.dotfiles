-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = {
    'go', 'lua', 'python', 'rust', 'typescript', 'regex',
    'bash', 'markdown', 'markdown_inline', 'kdl', 'sql', 'org', 'terraform',
    'html', 'css', 'javascript', 'yaml', 'json', 'toml',
  },

  highlight = { enable = true },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<c-backspace>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
        ['ii'] = '@conditional.inner',
        ['ai'] = '@conditional.outer',
        ['il'] = '@loop.inner',
        ['al'] = '@loop.outer',
        ['at'] = '@comment.outer',
        ["ab"] = { query = "@block.outer", desc = "🌲select around block" },
		["ib"] = { query = "@block.inner", desc = "🌲select inside block" },
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
				["[f"] = { query = "@function.outer", desc = "🌲go to next function" },
				["[c"] = { query = "@class.outer", desc = "🌲go to next class" },
				["[l"] = { query = "@loop.outer", desc = "🌲go to next loop" },
				["[b"] = { query = "@block.outer", desc = "🌲go to next block" },
			},
      goto_previous_start = {
				["[F"] = { query = "@function.outer", desc = "🌲go to previous function" },
				["[C"] = { query = "@class.outer", desc = "🌲go to previous class" },
				["[L"] = { query = "@loop.outer", desc = "🌲go to previous loop" },
				["[B"] = { query = "@block.outer", desc = "🌲go to previous block" },
			},
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}


-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', '[D', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })

