return { -- Telescope
{
	"nvim-telescope/telescope.nvim",
	tag = "0.1.2",
	dependencies = { "nvim-lua/plenary.nvim" },
}, -- Treesitter
{
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
}, {
	"nvim-treesitter/playground",
}, { "nvim-treesitter/nvim-treesitter-textobjects" }, -- Other plugins
{
	"theprimeagen/refactoring.nvim",
}, {
	"mbbill/undotree",
}, {
	"preservim/tagbar",
}, {
	"tpope/vim-commentary",
}, {
	"hrsh7th/cmp-nvim-lua",
}, {
	"hrsh7th/cmp-nvim-lsp-signature-help",
}, {
	"hrsh7th/cmp-vsnip",
}, {
	"hrsh7th/cmp-buffer",
}, {
	"hrsh7th/cmp-path",
}, {
	"hrsh7th/vim-vsnip",
}, {
	"SirVer/ultisnips",
}, { "honza/vim-snippets" }, { "windwp/nvim-ts-autotag" }, -- LSP and completion
{
	"VonHeikemen/lsp-zero.nvim",
	branch = "v2.x",
	dependencies = { { "neovim/nvim-lspconfig" }, {
		"williamboman/mason.nvim",
		build = function()
			pcall(vim.cmd, "MasonUpdate")
		end,
	}, {
		"williamboman/mason-lspconfig.nvim",
	}, {
		"hrsh7th/nvim-cmp",
	}, { "hrsh7th/cmp-nvim-lsp" }, { "L3MON4D3/LuaSnip" } },
}, -- Neogit and related plugins
{
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"sindrets/diffview.nvim",
		"nvim-telescope/telescope.nvim",
		"ibhagwan/fzf-lua",
		"echasnovski/mini.pick",
	},
}, {
	"echasnovski/mini.pick",
}, { "sindrets/diffview.nvim" }, { "nvim-lua/plenary.nvim" }, -- Autopairs
{
	"windwp/nvim-autopairs",
	config = function()
		require("nvim-autopairs").setup{}
	end,
} }
