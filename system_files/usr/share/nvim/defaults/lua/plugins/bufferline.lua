return {
  {
    "akinsho/bufferline.nvim",
    enabled = false,
    opts = {
      options = {
        always_show_bufferline = false,
        middle_mouse_command = function(n)
          LazyVim.ui.bufremove(n)
        end,
        -- separator_style = "slant",
      },
    },
  },
}
