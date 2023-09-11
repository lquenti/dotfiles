require("nvim-tree").setup({
  renderer = {
    icons = {
      web_devicons = {
        file = {
          enable = false,
          color = false,
        },
        folder = {
          enable = false,
          color = false,
        }
      },
      glyphs = {
        default = "-", -- is a file
        symlink = "-", -- is a symlink
        bookmark = "b", -- is a bookmark?
        modified = "●",
        folder = {
          arrow_closed = "-", -- collapsed
          arrow_open = "-", -- not collapsed
          default = "/", -- is a normal folder
          open = "/", -- is a non-collapsed folder
          empty = "/", -- ...
          empty_open = "/",
          symlink = "/",
          symlink_open = "/",
        }
      }
    }
  }
})
