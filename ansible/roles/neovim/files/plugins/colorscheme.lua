-- Colorscheme configuration
-- LazyVim comes with tokyonight, but you can customize here

return {
  {
    "LazyVim/LazyVim",
    opts = {
      -- Use tokyonight by default (comes with LazyVim)
      colorscheme = "tokyonight",
    },
  },

  -- Configure tokyonight
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "night", -- Options: storm, moon, night, day
      transparent = false,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
      },
    },
  },
}
