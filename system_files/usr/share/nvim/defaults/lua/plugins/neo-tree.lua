return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
    opts = {
      window = {
        width = 36,
      },
      filesystem = {
        filtered_items = {
          always_show = {
            ".gitignore",
          },
          always_show_by_pattern = {
            ".env*",
            "*vault.yml",
          },
          never_show_by_pattern = {
            "*.bak",
          },
        },
      },
    },
  },
}
