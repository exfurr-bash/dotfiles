-- Tokyo Night Neovim Config

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = "▸ ", trail = "·" }
vim.opt.scrolloff = 8
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"

vim.cmd.colorscheme("tokyonight")

require("lazy").setup({
  { "folke/tokyonight.nvim", priority = 1000, config = true },
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "numToStr/Comment.nvim", config = true },
  { "windwp/nvim-autopairs", config = true },
  { "folke/which-key.nvim", config = true },
  { "akinsho/bufferline.nvim", dependencies = "nvim-tree/nvim-web-devicons", config = true },
  { "nvim-lualine/lualine.nvim", dependencies = "nvim-tree/nvim-web-devicons", config = true },
  { "neovim/nvim-lspconfig" },
  { "hrsh7th/nvim-cmp", dependencies = {
    "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path",
    "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip"
  } },
  { "williamboman/mason.nvim", config = true },
  { "williamboman/mason-lspconfig.nvim", config = true },
  { "lewis6991/gitsigns.nvim", config = true },
  { "nvim-tree/nvim-tree.lua", dependencies = "nvim-tree/nvim-web-devicons" },
})

local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local servers = { "lua_ls", "rust_analyzer", "pyright", "ts_ls", "gopls", "clangd" }
for _, server in ipairs(servers) do
  lspconfig[server].setup({ capabilities = capabilities })
end

local map = vim.keymap.set
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>")
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>")
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>")
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>")
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>")
map("n", "gd", vim.lsp.buf.definition)
map("n", "K", vim.lsp.buf.hover)
map("n", "<leader>rn", vim.lsp.buf.rename)
map("n", "<leader>ca", vim.lsp.buf.code_action)
map("n", "<leader>fmt", vim.lsp.buf.format)
map("n", "[d", vim.diagnostic.goto_prev)
map("n", "]d", vim.diagnostic.goto_next)
