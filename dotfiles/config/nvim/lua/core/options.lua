-- NOTE:    NeoVIM Global Options
--          See `:help vim.g'

-- See :help mapleader.
vim.g.mapleader = ' '				-- Setting the mapleader key.
vim.g.maplocalleader = ' '

vim.g.have_nerd_fonts = true		-- Enable/Disable nerd font support.

-- NOTE:    NeoVIM Options
--          See `:help vim.opt'

-- See :help vim.opt.
vim.opt.termguicolors = true        -- Enable/Disable 24-bit RGB color.

vim.opt.number = true				-- Enable/Disable line number.
vim.opt.relativenumber = true		-- Enable/Disable relative line number.

vim.opt.mouse = 'a'				    -- Enable/Disable mouse mode in NeoVIM.

vim.opt.showmode = false            -- Enable/Disable mode (If status line installed disable this option).

vim.schedule(                       -- Sync clipboard between OS and Neovim. 
function()                          -- Schedule the setting after `UiEnter` because it can increase startup-time.
vim.opt.clipboard = 'unnamedplus'
end
)                                

vim.opt.breakindent = true          -- Enable/Diasble breakindent.

vim.opt.undofile = true          -- Save undo history 

vim.opt.ignorecase = true			-- Enable/Disable case-insensitive search.
vim.opt.smartcase = true			-- Unless \C or one or more capital letter in the search term.

vim.opt.signcolumn = 'yes'          -- Keep signcolumn on by default

vim.opt.updatetime = 250            -- Decrease update time
vim.opt.timeoutlen = 300            -- Decrease mapped sequence wait time

vim.opt.splitright = true			-- New splits opens from right side.
vim.opt.splitbelow = true			-- New splits opens from below.

vim.opt.inccommand = "split"        -- Show the search word in a split.

vim.opt.cursorline = true			-- Show which line cursor is on.

vim.opt.scrolloff = 10				-- Minimal number of screen lines to keep above & below the cursor.

vim.opt.confirm = true              -- Raise dialog asking to save the current file. See `:help 'confirm'`

-- vim.opt.wrap = true				    -- Enable/Disable line wrapping.

vim.opt.linebreak = true            -- Enable/Disable line break.

vim.opt.expandtab = true			-- Use spaces instead of tabs.
vim.opt.tabstop = 4			    	-- Use 4 characters of space when pressing tab.
vim.opt.shiftwidth = 4				-- Number of spaces used for auto indent.
vim.opt.virtualedit = "block"		-- Enable/Disable virtualedit mode in Visul Block mode (Ctrl+v).

-- NOTE:    Autocommands
--          See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})
