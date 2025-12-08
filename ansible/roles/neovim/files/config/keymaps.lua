-- Custom keymaps for LazyVim
-- This file is automatically loaded by LazyVim

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Set leader key (LazyVim uses space by default, but defining explicitly)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Better window navigation
keymap.set("n", "<C-h>", "<C-w>h", opts)
keymap.set("n", "<C-j>", "<C-w>j", opts)
keymap.set("n", "<C-k>", "<C-w>k", opts)
keymap.set("n", "<C-l>", "<C-w>l", opts)

-- Resize windows with arrows
keymap.set("n", "<C-Up>", ":resize -2<CR>", opts)
keymap.set("n", "<C-Down>", ":resize +2<CR>", opts)
keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap.set("n", "<S-l>", ":bnext<CR>", opts)
keymap.set("n", "<S-h>", ":bprevious<CR>", opts)

-- Clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- Delete without copying to clipboard
keymap.set("n", "<leader>d", '"_d', { desc = "Delete without yank" })
keymap.set("v", "<leader>d", '"_d', { desc = "Delete without yank" })

-- Better paste in visual mode (don't overwrite clipboard)
keymap.set("v", "p", '"_dP', opts)

-- Stay in indent mode
keymap.set("v", "<", "<gv", opts)
keymap.set("v", ">", ">gv", opts)

-- Move text up and down
keymap.set("v", "J", ":m '>+1<CR>gv=gv", opts)
keymap.set("v", "K", ":m '<-2<CR>gv=gv", opts)

-- Keep cursor centered when scrolling
keymap.set("n", "<C-d>", "<C-d>zz", opts)
keymap.set("n", "<C-u>", "<C-u>zz", opts)
keymap.set("n", "n", "nzzzv", opts)
keymap.set("n", "N", "Nzzzv", opts)

-- Quick save
keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save file" })

-- Quick quit
keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit" })

-- Split windows
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<leader>sx", ":close<CR>", { desc = "Close current split" })
