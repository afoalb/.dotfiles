-- -----------------
-- MINIMAL NEOVIM CONFIG FOR LSP DEVELOPMENT
-- ------------------


-- -----------------
-- BASIC OPTIONS
-- -----------------
vim.g.mapleader = ' '               -- Space as leader key (must be set before plugins)
vim.g.maplocalleader = '\\'         -- Backslash as local leader

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

-- ------------------
-- LAZY.NVIM BOOTSTRAP
-- ------------------
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

    -- Autocompletion
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

    -- Colorscheme: Catppuccin (Apple-ish, soft pastels)
    -- Flavors: latte (light), frappe (medium), macchiato (warm dark), mocha (dark)
    {
        'catppuccin/nvim',
        name = 'catppuccin',
        lazy = false,
        priority = 1000,
        opts = {
            flavour = 'macchiato',  -- latte, frappe, macchiato, mocha
            background = {
                light = 'latte',
                dark = 'macchiato',
            },
            transparent_background = false,
            term_colors = true,
            integrations = {
                cmp = true,
                gitsigns = true,
                nvimtree = true,
                telescope = true,
                treesitter = true,
                which_key = true,
                native_lsp = {
                    enabled = true,
                },
            },
        },
        config = function(_, opts)
            require('catppuccin').setup(opts)
            vim.cmd([[colorscheme catppuccin]])
        end,
    },

    -- Alternative: Keep tokyonight available (comment out catppuccin above to use)
    -- {
    --     'folke/tokyonight.nvim',
    --     lazy = false,
    --     priority = 1000,
    --     opts = {
    --         on_highlights = function(hl, c)
    --             hl['@string.documentation.python'] = { fg = c.comment }
    --         end,
    --     },
    --     config = function(_, opts)
    --         require('tokyonight').setup(opts)
    --         vim.cmd([[colorscheme tokyonight-night]])
    --     end,
    -- },

    -- Treesitter for better syntax highlighting
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        lazy = false,
        priority = 100,
        config = function()
            local status_ok, configs = pcall(require, 'nvim-treesitter.configs')
            if not status_ok then
                vim.notify('Treesitter not installed yet. Run :Lazy sync', vim.log.levels.WARN)
                return
            end

            configs.setup({
                ensure_installed = { 
                    'python', 
                    'typescript', 
                    'tsx', 
                    'javascript', 
                    'lua', 
                    'yaml', 
                    'hcl', 
                    'bash',
                },
                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
    },

    -- Auto-formatting
    {
        'stevearc/conform.nvim',
        event = { 'BufWritePre' },
        cmd = { 'ConformInfo' },
        keys = {
            {
                '<leader>fm',
                function()
                    require('conform').format({ async = true, lsp_fallback = true })
                end,
                mode = '',
                desc = 'Format buffer',
            },
        },
        opts = {
            formatters_by_ft = {
                python = { 'black' },
                javascript = { 'prettier' },
                typescript = { 'prettier' },
                typescriptreact = { 'prettier' },
                yaml = { 'prettier' },
                terraform = { 'terraform_fmt' },
                hcl = { 'terraform_fmt' },
            },
            format_on_save = {
                timeout_ms = 3000,
                lsp_fallback = true,
            },
        },
    },

    -- Comments
    -- Keymaps:
    --   gcc = Toggle line comment
    --   gcp = Toggle comment on paragraph/block
    --   gcA = Add comment at end of line
    --   gc  = Toggle comment (visual mode)
    {
        'numToStr/Comment.nvim',
        lazy = false,
        config = function()
            require('Comment').setup({
                -- Default mappings: gcc, gbc, gc (visual)
                toggler = {
                    line = 'gcc',   -- Line-comment toggle
                    block = 'gbc',  -- Block-comment toggle
                },
                opleader = {
                    line = 'gc',    -- Line-comment operator (gc + motion)
                    block = 'gb',   -- Block-comment operator (gb + motion)
                },
                extra = {
                    above = 'gcO',  -- Add comment on line above
                    below = 'gco',  -- Add comment on line below
                    eol = 'gcA',    -- Add comment at end of line
                },
            })

            -- Custom mapping: gcp = comment paragraph (gc + ip)
            vim.keymap.set('n', 'gcp', 'gcip', { remap = true, desc = 'Comment paragraph' })
        end,
    },

    -- TODO Comments Highlighting
    -- Highlights TODO, FIX, HACK, WARN, PERF, NOTE, TEST in comments
    -- Usage:
    --   :TodoQuickFix  - Show all TODOs in quickfix
    --   :TodoTelescope - Search TODOs with Telescope
    --   ]t / [t        - Jump to next/prev TODO
    {
        'folke/todo-comments.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        event = 'VeryLazy',
        opts = {
            signs = true,      -- Show signs in the gutter
            sign_priority = 8,
            keywords = {
                FIX =  { icon = ' ', color = 'error', alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' } },
                TODO = { icon = ' ', color = 'info' },
                HACK = { icon = ' ', color = 'warning' },
                WARN = { icon = ' ', color = 'warning', alt = { 'WARNING', 'XXX' } },
                PERF = { icon = ' ', color = 'default', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
                NOTE = { icon = ' ', color = 'hint', alt = { 'INFO' } },
                TEST = { icon = '⏲ ', color = 'test', alt = { 'TESTING', 'PASSED', 'FAILED' } },
            },
            highlight = {
                multiline = true,
                multiline_pattern = '^.',
                multiline_context = 10,
                before = '',           -- Don't highlight before the keyword
                keyword = 'wide',      -- Highlight the keyword and surrounding characters
                after = 'fg',          -- Highlight text after the keyword
                pattern = [[.*<(KEYWORDS)\s*:]],  -- Pattern: "TODO:" or "# TODO:"
                comments_only = true,  -- Only highlight in comments
            },
            colors = {
                error = { 'DiagnosticError', 'ErrorMsg', '#DC2626' },
                warning = { 'DiagnosticWarn', 'WarningMsg', '#FBBF24' },
                info = { 'DiagnosticInfo', '#2563EB' },
                hint = { 'DiagnosticHint', '#10B981' },
                default = { 'Identifier', '#7C3AED' },
                test = { 'Identifier', '#FF00FF' },
            },
            search = {
                command = 'rg',
                args = {
                    '--color=never',
                    '--no-heading',
                    '--with-filename',
                    '--line-number',
                    '--column',
                },
                pattern = [[\b(KEYWORDS):]],  -- ripgrep pattern
            },
        },
    },

    -- Which-key
    {
        'folke/which-key.nvim',
        event = 'VeryLazy',
        config = function()
            local wk = require('which-key')
            wk.setup({
                icons = { mappings = false },
            })

            -- Register groups for leader key mappings
            wk.add({
                { "<leader>f", group = "Find/Files" },
                { "<leader>g", group = "Git" },
                { "<leader>s", group = "Search/Replace" },
                { "<leader>c", group = "Code/Quickfix" },
                { "<leader>r", group = "Refactor" },
                { "<leader>b", group = "Buffers/Tabs" },
                { "<leader>t", group = "TODOs" },
            })

            -- =====================================================
            -- CHEATSHEET: Document Vim built-in commands here
            -- Press <leader> and wait to see all registered keymaps
            -- =====================================================
            wk.add({
                -- Window management (Ctrl-w prefix) - ALIGNED WITH TMUX Ctrl-a
                -- Same mental model: Ctrl-w for vim windows, Ctrl-a for tmux panes
                { "<C-w>", group = "Windows (like tmux Ctrl-a)" },
                { "<C-w>h", desc = "Go to left window" },
                { "<C-w>j", desc = "Go to below window" },
                { "<C-w>k", desc = "Go to above window" },
                { "<C-w>l", desc = "Go to right window" },
                { "<C-w>|", desc = "Split vertical (side) [tmux: C-a |]" },
                { "<C-w>-", desc = "Split horizontal (below) [tmux: C-a -]" },
                { "<C-w>n", desc = "Next buffer [tmux: C-a n]" },
                { "<C-w>p", desc = "Previous buffer [tmux: C-a p]" },
                { "<C-w>x", desc = "Close window [tmux: C-a x]" },
                { "<C-w>X", desc = "Close buffer [tmux: C-a X]" },
                { "<C-w>O", desc = "Close all OTHER windows" },
                { "<C-w>o", desc = "Close all other windows (same as O)" },
                { "<C-w>=", desc = "Equal size windows" },
                { "<C-w>m", desc = "Maximize window [tmux: C-a m]" },
                { "<C-w>M", desc = "Unmaximize window" },
                { "<C-w><", desc = "Rotate windows backward [tmux: C-a <]" },
                { "<C-w>>", desc = "Rotate windows forward [tmux: C-a >]" },
                { "<C-w><C-h>", desc = "Decrease width [tmux: C-a C-h]" },
                { "<C-w><C-l>", desc = "Increase width [tmux: C-a C-l]" },
                { "<C-w><C-j>", desc = "Decrease height [tmux: C-a C-j]" },
                { "<C-w><C-k>", desc = "Increase height [tmux: C-a C-k]" },

                -- Navigation
                { "g", group = "Go to / LSP" },
                { "gd", desc = "Go to definition (LSP)" },
                { "gr", desc = "Go to references (LSP)" },
                { "gI", desc = "Go to implementation (LSP)" },
                { "gg", desc = "Go to first line" },
                { "G", desc = "Go to last line" },
                { "gf", desc = "Go to file under cursor" },
                { "gi", desc = "Go to last insert position" },

                -- Marks and jumps
                { "'", group = "Marks" },
                { "''", desc = "Jump to last position" },
                { "'.", desc = "Jump to last change" },
                { "m", group = "Set mark (m + letter)" },

                -- Text objects (visual mode / operators)
                { "i", group = "Inner text object", mode = { "o", "v" } },
                { "iw", desc = "Inner word", mode = { "o", "v" } },
                { "iW", desc = "Inner WORD", mode = { "o", "v" } },
                { "ib", desc = "Inner parentheses ()", mode = { "o", "v" } },
                { "iB", desc = "Inner braces {}", mode = { "o", "v" } },
                { 'i"', desc = "Inner double quotes", mode = { "o", "v" } },
                { "i'", desc = "Inner single quotes", mode = { "o", "v" } },
                { "it", desc = "Inner tag <tag></tag>", mode = { "o", "v" } },
                { "ip", desc = "Inner paragraph", mode = { "o", "v" } },

                { "a", group = "Around text object", mode = { "o", "v" } },
                { "aw", desc = "Around word", mode = { "o", "v" } },
                { "ab", desc = "Around parentheses ()", mode = { "o", "v" } },
                { "aB", desc = "Around braces {}", mode = { "o", "v" } },
                { 'a"', desc = "Around double quotes", mode = { "o", "v" } },
                { "at", desc = "Around tag", mode = { "o", "v" } },
                { "ap", desc = "Around paragraph", mode = { "o", "v" } },

                -- Folding
                { "z", group = "Folds/View" },
                { "za", desc = "Toggle fold" },
                { "zo", desc = "Open fold" },
                { "zc", desc = "Close fold" },
                { "zR", desc = "Open ALL folds" },
                { "zM", desc = "Close ALL folds" },
                { "zz", desc = "Center cursor line" },
                { "zt", desc = "Cursor line to top" },
                { "zb", desc = "Cursor line to bottom" },

                -- Quickfix (with bqf)
                { "]q", desc = "Next quickfix item" },
                { "[q", desc = "Prev quickfix item" },
                { "]Q", desc = "Last quickfix item" },
                { "[Q", desc = "First quickfix item" },

                -- Diagnostics
                { "]d", desc = "Next diagnostic" },
                { "[d", desc = "Prev diagnostic" },

                -- TODOs
                { "]t", desc = "Next TODO comment" },
                { "[t", desc = "Prev TODO comment" },

                -- Comment.nvim
                { "gc", group = "Comment" },
                { "gcc", desc = "Toggle line comment" },
                { "gbc", desc = "Toggle block comment" },
                { "gcp", desc = "Comment paragraph" },
                { "gcA", desc = "Comment at end of line" },
                { "gcO", desc = "Comment line above" },
                { "gco", desc = "Comment line below" },
                { "gc", desc = "Comment selection", mode = "v" },

                -- Search
                { "/", desc = "Search forward" },
                { "?", desc = "Search backward" },
                { "n", desc = "Next search result" },
                { "N", desc = "Prev search result" },
                { "*", desc = "Search word under cursor (forward)" },
                { "#", desc = "Search word under cursor (backward)" },

                -- Registers
                { '"', group = "Registers" },
                { '"+', desc = "System clipboard", mode = { "n", "v" } },
                { '"0', desc = "Yank register (last yank)", mode = { "n", "v" } },

                -- Macros
                { "q", desc = "Record macro (q + register)" },
                { "@", group = "Play macro" },
                { "@@", desc = "Repeat last macro" },

                -- Useful combos
                { "ciw", desc = "Change inner word" },
                { "diw", desc = "Delete inner word" },
                { "yiw", desc = "Yank inner word" },
                { "ci(", desc = "Change inside ()" },
                { "ci{", desc = "Change inside {}" },
                { 'ci"', desc = 'Change inside ""' },
                { "da(", desc = "Delete around ()" },
                { "va{", desc = "Select around {}" },

                -- nvim-tree (inside tree window)
                -- a     = Create file/folder (end with / for folder)
                -- d     = Delete
                -- r     = Rename
                -- x     = Cut
                -- c     = Copy
                -- p     = Paste
                -- y     = Copy filename
                -- Y     = Copy relative path
                -- gy    = Copy absolute path
                -- <CR>  = Open file
                -- <C-v> = Open in vertical split
                -- <C-x> = Open in horizontal split
                -- I     = Toggle hidden files
                -- H     = Toggle dotfiles
                -- R     = Refresh
                -- ?     = Show help
            })
        end,
    },

    -- Autopairs (auto-close brackets, quotes, etc)
    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        config = true,
    },

    -- Better Quickfix List
    -- Usage: After :grep, :vimgrep, :TodoQuickFix, or LSP references, open with :copen
    -- Keys in quickfix: o=open, p=preview, zf=fuzzy filter, <Tab>=select
    {
        'kevinhwang91/nvim-bqf',
        ft = 'qf',
    },

    -- File Explorer
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('nvim-tree').setup({
                view = {
                    width = 35,
                    side = 'left',
                },
                renderer = {
                    group_empty = true,  -- Collapse empty folders
                    icons = {
                        show = {
                            file = false,
                            folder = false,
                            folder_arrow = true,
                            git = true,
                        },
                    },
                },
                filters = {
                    dotfiles = false,
                    custom = { '__pycache__', 'node_modules', '.git' },
                },
                update_focused_file = {
                    enable = true,       -- Highlight current file in tree
                    update_cwd = false,
                },
                git = {
                    enable = true,
                    ignore = false,      -- Show git-ignored files (greyed out)
                },
                actions = {
                    open_file = {
                        quit_on_open = false,  -- Keep tree open when opening file
                        resize_window = true,
                    },
                },
                on_attach = function(bufnr)
                    local api = require('nvim-tree.api')
                    
                    -- Default mappings
                    api.config.mappings.default_on_attach(bufnr)
                    
                    -- Custom mapping for help
                    local opts = { buffer = bufnr, noremap = true, silent = true, desc = 'Show help' }
                    vim.keymap.set('n', '?', api.tree.toggle_help, opts)
                end,
            })
        end,
    },

    -- Tab Bar (Buffer Line)
    {
        'akinsho/bufferline.nvim',
        version = '*',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('bufferline').setup({
                options = {
                    mode = 'buffers',                    -- Show buffers (not tabs)
                    numbers = 'ordinal',                 -- Show buffer numbers (1, 2, 3...)
                    close_command = 'bdelete! %d',
                    right_mouse_command = 'bdelete! %d',
                    left_mouse_command = 'buffer %d',
                    middle_mouse_command = nil,
                    
                    indicator = {
                        style = 'icon',
                        icon = '▎',
                    },
                    
                    buffer_close_icon = '×',
                    modified_icon = '●',
                    close_icon = '',
                    left_trunc_marker = '',
                    right_trunc_marker = '',
                    
                    max_name_length = 30,
                    max_prefix_length = 15,
                    truncate_names = true,
                    tab_size = 20,
                    
                    diagnostics = 'nvim_lsp',            -- Show LSP diagnostics in tabs
                    diagnostics_update_in_insert = false,
                    diagnostics_indicator = function(count, level)
                        local icon = level:match('error') and ' ' or ' '
                        return ' ' .. icon .. count
                    end,
                    
                    -- Don't show bufferline over nvim-tree
                    offsets = {
                        {
                            filetype = 'NvimTree',
                            text = 'File Explorer',
                            text_align = 'center',
                            separator = true,
                        },
                    },
                    
                    color_icons = true,
                    show_buffer_icons = true,
                    show_buffer_close_icons = true,
                    show_close_icon = false,
                    show_tab_indicators = true,
                    show_duplicate_prefix = true,
                    persist_buffer_sort = true,
                    
                    separator_style = 'thin',            -- 'slant', 'thick', 'thin', 'padded_slant'
                    enforce_regular_tabs = false,
                    always_show_bufferline = true,
                    
                    hover = {
                        enabled = true,
                        delay = 200,
                        reveal = { 'close' },
                    },
                    
                    sort_by = 'insert_after_current',
                },
            })
        end,
    },

})

-- -----------------
-- LSP SETUP
-- -----------------
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

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local function setup_lsp(server_name, settings)
    vim.lsp.config(server_name, {
        capabilities = capabilities,
        settings = settings or {},
    })
    vim.lsp.enable(server_name)
end

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

setup_lsp('ts_ls')

setup_lsp('yamlls', {
    yaml = {
        schemas = {
            ["https://raw.githubusercontent.com/ansible/schemas/main/f/ansible.json"] = "/*playbook*.{yml,yaml}",
        },
    }
})

setup_lsp('terraformls')

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
-- DEFENSIVE CODING NOTE (Dec 2024):
-- This implementation is intentionally defensive due to a subtle Telescope bug.
--
-- THE PROBLEM:
-- When using live_grep on a file OUTSIDE the current working directory (e.g.,
-- editing ~/.config/nvim/init.lua while CWD is ~/projects/myapp), Telescope's
-- previewer creates a temporary buffer with a malformed name (just "]").
-- If you select a grep result from that file, entry.filename returns "]" instead
-- of the actual file path. A naive implementation would then run `:edit ]`,
-- creating a REAL FILE named "]" in your CWD — which then appears in future
-- grep results, perpetuating the bug.
--
-- THE SOLUTION:
-- 1. Capture the original buffer/window BEFORE Telescope opens (not after close)
-- 2. Validate extracted filenames (reject "]", "[", or paths ending in brackets)
-- 3. Fall back to navigating within the original buffer when filename is invalid
--
-- -----------------
local telescope = require('telescope')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

-- Helper: Get canonical path
local function get_canonical_path(path)
    if not path or path == '' or type(path) ~= 'string' then return nil end
    local expanded = vim.fn.expand(path)
    local resolved = vim.fn.resolve(expanded)
    return vim.fn.fnamemodify(resolved, ':p')
end

-- Helper: Check if a filename is valid (not garbage like "]")
local function is_valid_filename(filename)
    if not filename or type(filename) ~= 'string' then return false end
    if #filename < 2 then return false end  -- Too short
    if filename:match('^[%[%]]+$') then return false end  -- Just brackets
    if filename:match('[%[%]]$') then return false end  -- Ends with bracket
    return true
end

-- Helper: Extract valid file path from telescope entry
local function get_entry_path(entry, cwd)
    if not entry then return nil end
    
    -- Try entry.filename first
    if is_valid_filename(entry.filename) then
        local full_path
        if vim.fn.fnamemodify(entry.filename, ':p') == entry.filename then
            -- Already absolute
            full_path = entry.filename
        else
            -- Relative - combine with cwd
            full_path = (cwd or vim.fn.getcwd()) .. '/' .. entry.filename
        end
        if vim.fn.filereadable(full_path) == 1 then
            return get_canonical_path(full_path)
        end
    end
    
    -- Try entry.path
    if is_valid_filename(entry.path) then
        local full_path = entry.path
        if vim.fn.filereadable(full_path) == 1 then
            return get_canonical_path(full_path)
        end
    end
    
    -- Cannot extract valid path
    return nil
end

-- Global storage for pre-Telescope context
_G._telescope_ctx = nil

local function capture_context()
    _G._telescope_ctx = {
        bufnr = vim.api.nvim_get_current_buf(),
        winnr = vim.api.nvim_get_current_win(),
        file = get_canonical_path(vim.api.nvim_buf_get_name(0)),
    }
end

-- Custom select action
local function smart_open(prompt_bufnr)
    local entry = action_state.get_selected_entry()
    if not entry then
        actions.close(prompt_bufnr)
        return
    end
    
    -- Get the picker's cwd (from entry metatable)
    local picker_cwd = nil
    local mt = getmetatable(entry)
    if mt and mt.cwd then
        picker_cwd = mt.cwd
    end
    
    -- Extract target info
    local target_file = get_entry_path(entry, picker_cwd)
    local target_line = entry.lnum or 1
    local target_col = (entry.col or 1) - 1
    
    local orig = _G._telescope_ctx
    
    -- Close Telescope first
    actions.close(prompt_bufnr)
    
    vim.schedule(function()
        -- CASE 1: Invalid/corrupted filename (like "]")
        -- If we have original context, assume user is searching in current file
        if not target_file then
            if orig and orig.file and orig.bufnr then
                -- Navigate in original buffer
                if vim.api.nvim_win_is_valid(orig.winnr) then
                    vim.api.nvim_set_current_win(orig.winnr)
                end
                if vim.api.nvim_buf_is_valid(orig.bufnr) then
                    vim.api.nvim_set_current_buf(orig.bufnr)
                end
                
                local line_count = vim.api.nvim_buf_line_count(0)
                local safe_line = math.min(math.max(1, target_line), line_count)
                local line_text = vim.api.nvim_buf_get_lines(0, safe_line - 1, safe_line, false)[1] or ''
                local safe_col = math.min(math.max(0, target_col), math.max(0, #line_text - 1))
                
                vim.api.nvim_win_set_cursor(0, { safe_line, safe_col })
                vim.cmd('normal! zz')
                
                _G._telescope_ctx = nil
                return
            else
                -- No context, nothing we can do
                vim.notify("Could not determine target file", vim.log.levels.WARN)
                _G._telescope_ctx = nil
                return
            end
        end
        
        -- CASE 2: Valid filename extracted
        local is_same_file = orig 
            and orig.file 
            and target_file 
            and orig.file == target_file
        
        if is_same_file then
            -- Same file: navigate in original buffer
            if vim.api.nvim_win_is_valid(orig.winnr) then
                vim.api.nvim_set_current_win(orig.winnr)
            end
            if vim.api.nvim_buf_is_valid(orig.bufnr) then
                vim.api.nvim_set_current_buf(orig.bufnr)
            end
            
            local line_count = vim.api.nvim_buf_line_count(0)
            local safe_line = math.min(math.max(1, target_line), line_count)
            local line_text = vim.api.nvim_buf_get_lines(0, safe_line - 1, safe_line, false)[1] or ''
            local safe_col = math.min(math.max(0, target_col), math.max(0, #line_text - 1))
            
            vim.api.nvim_win_set_cursor(0, { safe_line, safe_col })
            vim.cmd('normal! zz')
        else
            -- Different file: open it
            if orig and vim.api.nvim_win_is_valid(orig.winnr) then
                vim.api.nvim_set_current_win(orig.winnr)
            end
            
            vim.cmd('edit ' .. vim.fn.fnameescape(target_file))
            local line_count = vim.api.nvim_buf_line_count(0)
            local safe_line = math.min(math.max(1, target_line), line_count)
            vim.api.nvim_win_set_cursor(0, { safe_line, math.max(0, target_col) })
            vim.cmd('normal! zz')
        end
        
        _G._telescope_ctx = nil
    end)
end

telescope.setup({
    defaults = {
        file_ignore_patterns = { 'node_modules', '.git', '__pycache__' },
        mappings = {
            i = {
                ['<CR>'] = smart_open,
                ['<C-x>'] = actions.select_horizontal,
                ['<C-v>'] = actions.select_vertical,
                -- Swapped navigation: C-p goes down, C-n goes up
                ['<C-p>'] = actions.move_selection_next,
                ['<C-n>'] = actions.move_selection_previous,
            },
            n = {
                ['<CR>'] = smart_open,
                ['<C-x>'] = actions.select_horizontal,
                ['<C-v>'] = actions.select_vertical,
                -- Swapped navigation: C-p goes down, C-n goes up
                ['<C-p>'] = actions.move_selection_next,
                ['<C-n>'] = actions.move_selection_previous,
            },
        },
    },
})

-- Keymaps with context capture
local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', function()
    capture_context()
    builtin.find_files()
end, { desc = 'Find Files' })

vim.keymap.set('n', '<leader>fg', function()
    capture_context()
    builtin.live_grep()
end, { desc = 'Grep Files' })

vim.keymap.set('n', '<leader>fb', function()
    capture_context()
    builtin.buffers()
end, { desc = 'Find Buffers' })

vim.keymap.set('n', '<leader>fh', function()
    capture_context()
    builtin.help_tags()
end, { desc = 'Find Help' })

-- -----------------
-- TODO COMMENTS KEYMAPS
-- -----------------
vim.keymap.set('n', '<leader>tt', ':TodoTelescope<CR>', { desc = 'Search TODOs (Telescope)' })
vim.keymap.set('n', '<leader>tq', ':TodoQuickFix<CR>', { desc = 'TODOs to Quickfix' })
vim.keymap.set('n', '<leader>tl', ':TodoLocList<CR>', { desc = 'TODOs to Location List' })

-- Jump between TODOs
vim.keymap.set('n', ']t', function()
    require('todo-comments').jump_next()
end, { desc = 'Next TODO' })

vim.keymap.set('n', '[t', function()
    require('todo-comments').jump_prev()
end, { desc = 'Previous TODO' })

-- -----------------
-- QUICKFIX KEYMAPS (for use with nvim-bqf)
-- -----------------
vim.keymap.set('n', '<leader>co', ':copen<CR>', { desc = 'Open Quickfix' })
vim.keymap.set('n', '<leader>cc', ':cclose<CR>', { desc = 'Close Quickfix' })
vim.keymap.set('n', ']q', ':cnext<CR>zz', { desc = 'Next Quickfix' })
vim.keymap.set('n', '[q', ':cprev<CR>zz', { desc = 'Prev Quickfix' })
vim.keymap.set('n', ']Q', ':clast<CR>zz', { desc = 'Last Quickfix' })
vim.keymap.set('n', '[Q', ':cfirst<CR>zz', { desc = 'First Quickfix' })

-- -----------------
-- FILE EXPLORER KEYMAPS
-- -----------------
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Toggle File Tree' })
vim.keymap.set('n', '<leader>E', ':NvimTreeFindFile<CR>', { desc = 'Find File in Tree' })

-- -----------------
-- BUFFER/TAB NAVIGATION (bufferline)
-- -----------------
vim.keymap.set('n', '<leader>bp', ':BufferLinePick<CR>', { desc = 'Pick Buffer' })
vim.keymap.set('n', '<leader>bc', ':BufferLinePickClose<CR>', { desc = 'Pick Buffer to Close' })
vim.keymap.set('n', '<leader>bo', ':BufferLineCloseOthers<CR>', { desc = 'Close Other Buffers' })
vim.keymap.set('n', '<leader>bl', ':BufferLineCloseLeft<CR>', { desc = 'Close Buffers to Left' })
vim.keymap.set('n', '<leader>br', ':BufferLineCloseRight<CR>', { desc = 'Close Buffers to Right' })

-- Navigate between buffers
vim.keymap.set('n', '<S-h>', ':BufferLineCyclePrev<CR>', { desc = 'Previous Buffer' })
vim.keymap.set('n', '<S-l>', ':BufferLineCycleNext<CR>', { desc = 'Next Buffer' })

-- Move buffers left/right in the tab bar
vim.keymap.set('n', '<A-h>', ':BufferLineMovePrev<CR>', { desc = 'Move Buffer Left' })
vim.keymap.set('n', '<A-l>', ':BufferLineMoveNext<CR>', { desc = 'Move Buffer Right' })

-- Go to buffer by number (1-9)
vim.keymap.set('n', '<leader>1', ':BufferLineGoToBuffer 1<CR>', { desc = 'Go to Buffer 1' })
vim.keymap.set('n', '<leader>2', ':BufferLineGoToBuffer 2<CR>', { desc = 'Go to Buffer 2' })
vim.keymap.set('n', '<leader>3', ':BufferLineGoToBuffer 3<CR>', { desc = 'Go to Buffer 3' })
vim.keymap.set('n', '<leader>4', ':BufferLineGoToBuffer 4<CR>', { desc = 'Go to Buffer 4' })
vim.keymap.set('n', '<leader>5', ':BufferLineGoToBuffer 5<CR>', { desc = 'Go to Buffer 5' })
vim.keymap.set('n', '<leader>6', ':BufferLineGoToBuffer 6<CR>', { desc = 'Go to Buffer 6' })
vim.keymap.set('n', '<leader>7', ':BufferLineGoToBuffer 7<CR>', { desc = 'Go to Buffer 7' })
vim.keymap.set('n', '<leader>8', ':BufferLineGoToBuffer 8<CR>', { desc = 'Go to Buffer 8' })
vim.keymap.set('n', '<leader>9', ':BufferLineGoToBuffer 9<CR>', { desc = 'Go to Buffer 9' })

-- Close current buffer without closing window
vim.keymap.set('n', '<leader>bd', ':bdelete<CR>', { desc = 'Delete Buffer' })
vim.keymap.set('n', '<leader>bD', ':bdelete!<CR>', { desc = 'Force Delete Buffer' })

-- -----------------
-- UTILITY COMMANDS
-- -----------------
vim.api.nvim_create_user_command('FixSyntax', function()
    local buf = vim.api.nvim_get_current_buf()
    local ft = vim.bo[buf].filetype
    if ft == '' then
        ft = vim.filetype.match({ buf = buf }) or ''
    end
    if ft ~= '' then
        pcall(vim.treesitter.start, buf, ft)
    end
    vim.cmd('syntax sync fromstart')
    print('Syntax refreshed: ' .. ft)
end, {})

vim.api.nvim_create_user_command('DebugBuffers', function()
    print("Current: buf=" .. vim.api.nvim_get_current_buf() .. " file='" .. vim.api.nvim_buf_get_name(0) .. "'")
    print("Buffers:")
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) then
            print(string.format("  [%d] '%s' ft=%s listed=%s", 
                buf, 
                vim.api.nvim_buf_get_name(buf),
                vim.bo[buf].filetype,
                tostring(vim.bo[buf].buflisted)))
        end
    end
end, {})

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
-- WINDOW MANAGEMENT (aligned with tmux Ctrl-a keybindings)
-- -----------------
-- Tmux uses Ctrl-a, Neovim uses Ctrl-w
-- Same logic, different prefix for muscle memory consistency
--
-- Navigation (same as tmux h/j/k/l)
vim.keymap.set('n', '<C-w>h', '<C-w>h', { desc = 'Go to left window' })
vim.keymap.set('n', '<C-w>j', '<C-w>j', { desc = 'Go to below window' })
vim.keymap.set('n', '<C-w>k', '<C-w>k', { desc = 'Go to above window' })
vim.keymap.set('n', '<C-w>l', '<C-w>l', { desc = 'Go to right window' })

-- Splits (aligned with tmux | and -)
vim.keymap.set('n', '<C-w>|', ':vsplit<CR>', { desc = 'Split vertical (side)' })
vim.keymap.set('n', '<C-w>-', ':split<CR>', { desc = 'Split horizontal (below)' })

-- Buffer/Tab navigation (aligned with tmux n/p)
vim.keymap.set('n', '<C-w>n', ':BufferLineCycleNext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<C-w>p', ':BufferLineCyclePrev<CR>', { desc = 'Previous buffer' })

-- Close windows (aligned with tmux x/X)
vim.keymap.set('n', '<C-w>x', ':close<CR>', { desc = 'Close current window' })
vim.keymap.set('n', '<C-w>X', ':bdelete<CR>', { desc = 'Close current buffer' })
vim.keymap.set('n', '<C-w>O', ':only<CR>', { desc = 'Close all other windows' })

-- Resize windows (aligned with tmux Ctrl-h/j/k/l)
vim.keymap.set('n', '<C-w><C-h>', ':vertical resize -5<CR>', { desc = 'Decrease width' })
vim.keymap.set('n', '<C-w><C-l>', ':vertical resize +5<CR>', { desc = 'Increase width' })
vim.keymap.set('n', '<C-w><C-j>', ':resize -3<CR>', { desc = 'Decrease height' })
vim.keymap.set('n', '<C-w><C-k>', ':resize +3<CR>', { desc = 'Increase height' })

-- Zoom/maximize window (like tmux Ctrl-a m)
-- Toggle between current window and fullscreen
vim.keymap.set('n', '<C-w>m', ':tab split<CR>', { desc = 'Maximize window (new tab)' })
vim.keymap.set('n', '<C-w>M', ':tabclose<CR>', { desc = 'Unmaximize (close tab)' })

-- Swap windows (like tmux < and >)
vim.keymap.set('n', '<C-w><', '<C-w>R', { desc = 'Rotate windows backward' })
vim.keymap.set('n', '<C-w>>', '<C-w>r', { desc = 'Rotate windows forward' })

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
-- SEARCH & REPLACE (words that cursor is currently on)
-- -----------------
-- Search for word under cursor across project
vim.keymap.set('n', '<leader>sw', function()
    capture_context()
    require('telescope.builtin').grep_string()
end, { desc = 'Search Word' })

-- Search and replace in current buffer
vim.keymap.set('n', '<leader>sr', ':%s/<C-r><C-w>//g<Left><Left>', { desc = 'Search Replace' })


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
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Show Diagnostic' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Diagnostic List' })
