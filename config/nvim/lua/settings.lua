local opt = vim.opt
local au = vim.au
local autocmd = vim.autocmd
-- indentation
opt.smartindent = true            -- will try to figure out how to indent.
opt.autoindent = true             -- follows indentation of previous lines unless smart indent thinks otherwise.
opt.tabstop = 4                   -- visual display of tabs
opt.shiftwidth = 4                 -- levels of indentation
opt.expandtab = true

-- use system clipboard instead of vim specific:
opt.clipboard = "unnamedplus"

-- Undo file history (can undo after reopening)
-- opt.undofile = true


-- use mouse
opt.mouse = "a"


-- code line settings
opt.number = true                 -- line numbers.
opt.cursorline = true             -- better visual indicator for current line.

-- ui


-- quality of life
opt.smartcase = true              -- insensitive case search when all lowercase.
opt.compatible = false            -- compatability with vi.
-- opt.ttimeoutlen = 5            -- not sure if I want to use this yet, it changes wait time between commands.
-- opt.autoread = true            -- reloads file on outside change unless current buffers waiting (think git pull) same as :e.
opt.incsearch = true              -- will show search results incrementally highlighting as you go.
opt.hidden = true                 -- allows you to work with buffers without saving them, I want to test this out.
-- opt.shortmess = "atI"          -- this is related to stuff like swap files after crashes, will leave out for now.
-- au.FocusLost = " * :wa"

-- nvim file tree browser requirement, you can gooi custom settings in there, otherwise it assumes default.
require'nvim-tree'.setup {
}

