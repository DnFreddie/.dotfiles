return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "auto", -- latte, frappe, macchiato, mocha
        color_overrides = {
          latte = {
            base = "#ff0000",
            mantle = "#242424",
            crust = "#474747",
          },
          frappe = {},
          macchiato = {},
          mocha = {
            base = "#000000",
            mantle = "#000000",
            crust = "#000000",
          },
        }
      })
      vim.cmd.colorscheme "catppuccin-mocha"
    end
  }
}
