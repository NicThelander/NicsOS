local opt = vim.opt
local au = vim.au

-- indentation
opt.smartindent = true            -- will try to figure out how to indent.
opt.autoindent = true             -- follows indentation of previous lines unless smart indent thinks otherwise.

-- use system clipboard instead of vim specific:
opt.clipboard = "unnamedplus"

-- use mouse
opt.mouse = "a"

-- code line settings
opt.number = true                 -- line numbers.
opt.cursorline = true             -- better visual indicator for current line.

-- quality of life
opt.smartcase = true              -- insensitive case search when all lowercase.
opt.compatible = false            -- compatability with vi.
-- opt.ttimeoutlen = 5            -- not sure if I want to use this yet, it changes wait time between commands.
-- opt.autoread = true            -- reloads file on outside change unless current buffers waiting (think git pull) same as :e.
opt.incsearch = true              -- will show search results incrementally highlighting as you go.
opt.hidden = true                 -- allows you to work with buffers without saving them, I want to test this out.
-- opt.shortmess = "atI"          -- this is related to stuff like swap files after crashes, will leave out for now.
-- au.FocusLost = " * :wa"

