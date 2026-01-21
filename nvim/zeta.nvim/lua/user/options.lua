local options = {
	breakindent = true, -- @see https://stackoverflow.com/questions/1204149/smart-wrap-in-vim
	backup = false, -- creates a backup file
	cmdheight = 0, -- more space in the neovim command line for displaying messages
	completeopt = { "menu", "menuone", "noselect" }, -- mostly just for cmp
	colorcolumn = "100", -- adds a color column after 100 characters
	conceallevel = 0, -- so that `` is visible in markdown files
	fileencoding = "utf-8", -- the encoding written to a file
	hlsearch = true, -- highlight all matches on previous search pattern
	incsearch = true,
	ignorecase = true, -- ignore case in search patterns
	mouse = "a", -- allow the mouse to be used in neovim
	pumheight = 10, -- pop up menu height
	showmode = true, -- we don't need to see things like -- INSERT -- anymore
	showtabline = 2, -- always show tabs
	smartcase = true, -- smart case
	smartindent = true, -- make indenting smarter again
	splitbelow = true, -- force all horizontal splits to go below current window
	splitright = true, -- force all vertical splits to go to the right of current window
	swapfile = false, -- creates a swapfile
	termguicolors = true, -- set term gui colors (most terminals support this)
	timeoutlen = 300, -- time to wait for a mapped sequence to complete (in milliseconds)
	undofile = true, -- enable persistent undo
	updatetime = 300, -- faster completion (4000ms default)
	writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
	expandtab = true, -- convert tabs to spaces
	shiftwidth = 2, -- the number of spaces inserted for each indentation
	tabstop = 2, -- insert 2 spaces for a tab
	softtabstop = 2,
	cursorline = true, -- highlight the current line
	number = true, -- set numbered lines
	relativenumber = true, -- set relative numbered lines
	numberwidth = 4, -- set number column width to 2 {default 4}

	signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time
	wrap = true, -- display lines as one long line
	linebreak = true, -- companion to wrap, don't split words
	scrolloff = 16, -- minimal number of screen lines to keep above and below the cursor
	sidescrolloff = 8, -- minimal number of screen columns either side of cursor if wrap is `false`
	scrolljump = 1,
	virtualedit = "all",
	guifont = "monospace:h17", -- the font used in graphical neovim applications
	whichwrap = "bs<>[]hl", -- which "horizontal" keys are allowed to travel to prev/next line

	guicursor = {
		"n-v-c:block", -- Normal, visual, command-line: block cursor
		"i-ci-ve:ver25", -- Insert, command-line insert, visual-exclude: vertical bar cursor with 25% width
		"r-cr:hor20", -- Replace, command-line replace: horizontal bar cursor with 20% height
		"o:hor50", -- Operator-pending: horizontal bar cursor with 50% height
		-- "a:blinkwait700-blinkoff400-blinkon250", -- All modes: blinking settings
		"sm:block-blinkwait175-blinkoff150-blinkon175", -- Showmatch: block cursor with specific blinking settings
	},
}

for k, v in pairs(options) do
	vim.opt[k] = v
end

-- Completion.
vim.opt.wildignore:append({ ".DS_Store" })
-- vim.opt.shortmess = "ilmnrx"                        -- flags to shorten vim messages, see :help 'shortmess'
vim.opt.shortmess:append("c") -- don't give |ins-completion-menu| messages
vim.opt.iskeyword:append("-") -- hyphenated words recognized by searches
vim.opt.formatoptions:remove({ "c", "r", "o" }) -- don't insert the current comment leader automatically for auto-wrapping comments using 'textwidth', hitting <Enter> in insert mode, or hitting 'o' or 'O' in normal mode.
vim.opt.runtimepath:remove("/usr/share/vim/vimfiles") -- separate vim plugins from neovim in case vim still in use

local g = {
	-- Set vim options
	mapleader = " ",
	maplocalleader = " ",

	-- @see https://github.com/nvim-tree/nvim-tree.lua/blob/master/doc/nvim-tree-lua.txt
	loaded_netrw = 1,
	loaded_netrwPlugin = 1,
}

for k, v in pairs(g) do
	vim.g[k] = v
end

local o = {
	confirm = true, -- See `:help 'confirm'`
	grepprg = "rg --vimgrep", -- Use ripgrep for grepping.
	grepformat = "%f:%l:%c:%m",
	-- scrolloff = 999,-- this makes it so that we don't scroll, but the buffer scrolls around us
	sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions",
	list = true,
	inccommand = "split", -- Preview substitutions live, as you type!
}

for k, v in pairs(o) do
	vim.o[k] = v
end

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

-- vim: ts=2 sts=2 sw=2 et
