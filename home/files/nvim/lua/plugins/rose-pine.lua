return {
	"rose-pine/neovim",
	name = "rose-pine",
	lazy = false,
	-- above every other lazy = false plugin (snacks is 1000, lazy's default is 50), so
	-- anything that snapshots highlight groups at setup sees the final palette
	priority = 1001,
	config = function()
		vim.cmd.colorscheme("rose-pine-dawn")
	end,
}
