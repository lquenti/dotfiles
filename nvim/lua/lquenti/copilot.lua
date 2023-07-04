local status_ok, copilot = pcall(require, "copilot")
if not status_ok then
  return
end

-- Default settings besides comments
copilot.setup({
  panel = {
    enabled = false, -- disabled bc of copilot_cmp
    auto_refresh = false,
    keymap = {
      jump_prev = "[[",
      jump_next = "]]",
      accept = "<CR>",
      refresh = "gr",
      open = "<M-CR>"
    },
    layout = {
      position = "bottom", -- | top | left | right
      ratio = 0.4
    },
  },
  suggestion = {
    enabled = false, -- disabled bc of copilot_cmp
    auto_trigger = false,
    debounce = 75,
    keymap = {
      accept = "<M-l>",
      accept_word = false,
      accept_line = false,
      next = "<M-]>",
      prev = "<M-[>",
      dismiss = "<C-]>",
    },
  },
  filetypes = {
    yaml = false,
    markdown = false,
    help = false,
    gitcommit = false,
    gitrebase = false,
    hgcommit = false,
    svn = false,
    cvs = false,
    ["."] = false,
  },
  copilot_node_command = 'node', -- Node.js version must be > 16.x
  server_opts_overrides = {},
})

-- Copilot cmp
local status_ok, copilot_cmp = pcall(require, "copilot_cmp")
if not status_ok then
  return
end

copilot_cmp.setup()
