--[[ lazy bootstrap ]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)


--[[ neovim configurations ]]
local map = vim.keymap.set
local opt = vim.opt
local api = vim.api
local lsp = true

--[[ keybindings ]]
vim.g.mapleader = ","

map('n', '<TAB>', ':bnext<CR>')
map('n', '<S-TAB>', ':bprevious<CR>')
map('n', '<leader>e', ':NvimTreeToggle<CR>')
map('n', '<leader>b', ':bd<CR>')

map('n', "<leader>c", ':edit $MYVIMRC<CR>')


--[[ visual ]]
vim.cmd("colorscheme habamax")
opt.nu = true
opt.expandtab = true
opt.shiftwidth = 4


--[[ lazy setup ]]
require("lazy").setup({
    spec = {
        {
            "windwp/nvim-autopairs",
        },

        {
            "nvim-lualine/lualine.nvim",
            dependencies = { "nvim-tree/nvim-web-devicons" },
            config = function()
                require("lualine").setup({
                    options = {
                        theme = "iceberg_dark",
                    },
                })
            end,
        },

        {
            "mason-org/mason-lspconfig.nvim",
            dependencies = { "mason-org/mason.nvim" },
        },

        {
            "neovim/nvim-lspconfig",
            enabled = lsp
        },

        {
            "mason-org/mason.nvim",
            config = true,
        },

        {
            'saghen/blink.cmp',
            event = 'InsertEnter',
            dependencies = {
                {
                    'L3MON4D3/LuaSnip',
                    build = 'make install_jsregexp',
                    config = function()
                        local snip_folder = vim.fn.stdpath('config') .. '/snippets/'
                        api.nvim_create_user_command('LuaSnipEdit',
                            'lua require("luasnip.loaders").edit_snippet_files()',
                            {})
                        require('luasnip').setup({
                            history = true,
                            enable_autosnippets = true,
                            update_events = { 'TextChanged', 'TextChangedI' },
                            store_selection_keys =
                            '<C-q>'
                        })

                        require('luasnip.loaders.from_snipmate').lazy_load { paths = snip_folder }
                    end
                },
            },
            version = '1.*',
            opts = {
                keymap = {
                    preset = 'enter',
                    ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
                    ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
                },
                completion = {
                    accept = { auto_brackets = { enabled = true } },
                    documentation = { auto_show = true },
                    menu = { draw = { columns = { { 'label', 'label_description', 'source_name', gap = 1 } } } },
                },
                signature = { enabled = true },
                snippets = { preset = 'luasnip' },
            },
        },

        {
            "nvim-tree/nvim-tree.lua",
        },

        {
            "akinsho/bufferline.nvim",
            dependencies = "nvim-tree/nvim-web-devicons",
        },
    },

    checker = { enabled = true },
})


--[[ lsp configurations ]]
local lspconfig = require("lspconfig")

-- c/cpp
lspconfig.clangd.setup({})

-- lua
lspconfig.lua_ls.setup({})

-- python
lspconfig.pyright.setup({})


--[[ neovimtree configurations ]]
local nvimtree = require("nvim-tree")
nvimtree.setup({})

--[[ nvim-autopairs configurations ]]
local autopairs = require("nvim-autopairs")
autopairs.setup({})

--[[ bufferline configurations ]]
local bufferline = require("bufferline")
bufferline.setup({})
