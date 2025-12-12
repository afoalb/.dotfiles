-- -----------------
-- MINIMAL NEOVIM CONFIG FOR LSP DEVELOPMENT
-- ------------------

-- -----------------
-- BASIC OPTIONS
-- -----------------
vim.g.mapleader = '\\'              -- Space as leader key (must be set before plugins)
vim.g.maplocalleader = ' '         -- Local leader also space

vim.opt.number = true              -- Show line numbers
vim.opt.relativenumber = true      -- Relative line numbers for quick navigation
vim.opt.mouse = 'a'                -- Enable mouse support
vim.opt.ignorecase = true          -- Case insensitive search
vim.opt.smartcase = true           -- Unless capital letter in search
vim.opt.hlsearch = false           -- Don't highlight all search matches (less noisy)
vim.opt.wrap = false               -- Don't wrap lines
vim.opt.breakindent = true         -- Indent wrapped lines
vim.opt.tabstop = 4                -- Tab width
vim.opt.shiftwidth = 4             -- Indent width
vim.opt.expandtab = true           -- Use spaces instead of tabs
vim.opt.termguicolors = true       -- True color support
vim.opt.signcolumn = 'yes'         -- Always show sign column (for git/LSP signs)
vim.opt.updatetime = 250           -- Faster completion and diagnostics
vim.opt.undofile = true            -- Persistent undo history
vim.opt.splitright = true          -- Vertical splits go right
vim.opt.splitbelow = true          -- Horizontal splits go below
vim.opt.clipboard = 'unnamedplus'  -- Use system clipboard

# ------------------
-- LAZY.NVIM BOOTSTRAP
# ------------------
-- Auto-install lazy.nvim if not present
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable',
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- -----------------
-- PLUGINS
-- -----------------
require('lazy').setup({
    -- LSP Configuration & Plugins
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
        },
    },

    -- Autocompletion (used via Ctrl+X Ctrl+O)
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
        },
    },

    -- Fuzzy Finder
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },

    -- Git integration
    { 'lewis6991/gitsigns.nvim' },
    { 'tpope/vim-fugitive' },

    -- Colorscheme (optional - remove if you want default)
    {
        'folke/tokyonight.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd([[colorscheme tokyonight-night]])
        end,
    },
})

-- -----------------
-- LSP SETUP
-- -----------------
-- Ensure npm is in PATH for Mason
local homebrew_paths = {
    '/opt/homebrew/bin',
    '/opt/homebrew/opt/node/bin',
    '/usr/local/bin',
}

for _, path in ipairs(homebrew_paths) do
    local current_path = vim.env.PATH or ''
    if not string.find(current_path, path, 1, true) then
        vim.env.PATH = path .. ':' .. current_path
    end
end

-- Mason: Auto-install language servers
require('mason').setup()
require('mason-lspconfig').setup({
    ensure_installed = {
        'pyright',
        'ts_ls',
        'yamlls',
        'terraformls',
    },
    automatic_installation = true,
})

-- Get default capabilities for LSP
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Helper function to configure LSP servers
local function setup_lsp(server_name, settings)
    vim.lsp.config(server_name, {
        capabilities = capabilities,
        settings = settings or {},
    })
    vim.lsp.enable(server_name)
end

-- Python (Django)
setup_lsp('pyright', {
    python = {
        analysis = {
            typeCheckingMode = 'basic',
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            autoImportCompletions = true,
            diagnosticMode = "workspace",
        }
    }
})

-- TypeScript/React
setup_lsp('ts_ls')

-- YAML (Ansible)
setup_lsp('yamlls', {
    yaml = {
        schemas = {
            ["https://raw.githubusercontent.com/ansible/schemas/main/f/ansible.json"] = "/*playbook*.{yml,yaml}",
        },
    }
})

-- Terraform
setup_lsp('terraformls')

-- LSP Keybindings (set when LSP attaches to buffer)
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
    callback = function(event)
        local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        map('gd', vim.lsp.buf.definition, 'Goto Definition')
        map('gr', vim.lsp.buf.references, 'Goto References')
        map('gI', vim.lsp.buf.implementation, 'Goto Implementation')
        map('K', vim.lsp.buf.hover, 'Hover Documentation')
        map('<leader>rn', vim.lsp.buf.rename, 'Rename')
        map('<leader>ca', vim.lsp.buf.code_action, 'Code Action')
    end,
})

-- -----------------
-- AUTOCOMPLETION SETUP
-- -----------------
-- Simple setup: completions via Ctrl+X Ctrl+O (Vim's native omnifunc)
local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
    },
})

-- -----------------
-- TELESCOPE SETUP
-- -----------------
local telescope = require('telescope')
telescope.setup({
    defaults = {
        file_ignore_patterns = { 'node_modules', '.git', '__pycache__' },
    }
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find Files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Grep Files' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find Buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Find Help' })

-- -----------------
-- GIT INTEGRATION
-- -----------------
require('gitsigns').setup({
    signs = {
        add          = { text = '+' },
        change       = { text = '~' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
    },
})

vim.keymap.set('n', '<leader>gb', ':Git blame<CR>', { desc = 'Git Blame' })
vim.keymap.set('n', '<leader>gs', ':Git<CR>', { desc = 'Git Status' })
vim.keymap.set('n', '<leader>gd', ':Gvdiffsplit<CR>', { desc = 'Git Diff' })

-- -----------------
-- TERMINAL INTEGRATION
-- -----------------
vim.keymap.set('n', '<C-t>', ':terminal<CR>', { desc = 'Open Terminal' })
vim.keymap.set('t', '<C-t>', '<C-\\><C-n>', { desc = 'Exit Terminal Mode' })
vim.api.nvim_create_autocmd('TermOpen', {
    pattern = '*',
    command = 'startinsert'
})

-- -----------------
-- DIAGNOSTIC CONFIGURATION
-- -----------------
vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
})

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous Diagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next Diagnostic' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show Diagnostic' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Diagnostic List' })
