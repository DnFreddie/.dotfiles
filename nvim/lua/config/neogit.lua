-- lua/neogit_config.lua
require('neogit').setup {
  -- Add your Neogit configuration options here
}
vim.keymap.set("n", "<leader>gs", vim.cmd.Neogit)

