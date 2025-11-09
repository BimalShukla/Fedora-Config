-- NOTE: Install Lazy Plugins Manager

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- NOTE: Load Lazy Plugins

require("lazy").setup({
	"NMAC427/guess-indent.nvim", -- Detect tabstop and shiftwidth automatically

	require("plugins.autocompletion"),

	require("plugins.autopairs"),

	require("plugins.blink-cmp"),

	require("plugins.bufferline"),

	require("plugins.colorizer"),

	require("plugins.conform"),

	require("plugins.debug"),

	require("plugins.gitsigns"),

	require("plugins.indent_line"),

	require("plugins.lint"),

	require("plugins.lspconfig"),

	require("plugins.lualine"),

	require("plugins.mini"),

	require("plugins.neo-tree"),

	require("plugins.noice"),

	require("plugins.search-and-replace"),

	require("plugins.telescope"),

	require("plugins.theme"),

	require("plugins.todo-comments"),

	require("plugins.treesitter"),

	require("plugins.vertcolumn"),

	require("plugins.which-key"),
}, {
	ui = {
		-- If you are using a Nerd Font: set icons to an empty table which will use the
		-- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})
