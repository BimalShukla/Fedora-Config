return {
	{ -- Collection of various small independent plugins/modules
		"echasnovski/mini.nvim",
		config = function()
			-- Better Around/Inside textobjects
			-- Examples: va) : [V]isually select [A]round [)]paren | yinq : [Y]ank [I]nside [N]ext [Q]uote | ci" : [C]hange [I]nside ["]quote
			require("mini.ai").setup({
				n_lines = 500, -- Number of lines within which textobject is searched.
			})

			-- Fast and feature-rich surround actions
			-- saiw) : [S]urround [A]dd [I]nner [W]ord [)]Paren | sd' : [S]urround [D]elete [']quotes | sr)' : [S]urround [R]eplace [)] [']
			require("mini.surround").setup()

			-- Move any selection in any direction
			-- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
			require("mini.move").setup({})

			-- Minimal and fast autopairs.
			require("mini.pairs").setup({})

			-- Visualize and work with indent scope.
			require("mini.indentscope").setup({})
		end,
	},
}
