-- [ ] Sorted

-- Disable Netrw for nvim-tree since we overwrite it
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- :help options
vim.opt.backup = false                          -- No backup when saving
vim.opt.clipboard = "unnamedplus"               -- Normal system clipboard yanking
vim.opt.nu = true; vim.opt.rnu = true           -- Absolute relative line numbers
vim.opt.colorcolumn = "120"                     -- 120 char indicator
vim.opt.linebreak = true                        -- smart linebreak
vim.opt.expandtab = true                        -- convert tabs to spaces
vim.opt.tabstop = 2                             -- tab == 2 spaces
vim.opt.softtabstop = 2                         -- tab == 2 spaces
vim.opt.shiftwidth = 2                          -- tab == 2 spaces
vim.opt.cursorline = false                      -- no ugly cursorline
vim.opt.completeopt = { "menuone", "noselect" } -- mostly just for cmp
vim.opt.fileencoding = "utf-8"                  -- the encoding written to a file
vim.opt.hlsearch = true                         -- highlight all matches on previous search pattern
vim.opt.ignorecase = true                       -- ignore case in search patterns
vim.opt.mouse = ""                              -- disable the mouse
vim.opt.showmode = true                         -- show which mode we are on
vim.opt.smartcase = true                        -- smart case
vim.opt.scrolloff = 4                           -- minimal number of lines to keep above and below cursor
vim.opt.sidescrolloff = 4                       -- minimal number of lines to keep above and below cursor
vim.opt.termguicolors = true                    -- true color support
