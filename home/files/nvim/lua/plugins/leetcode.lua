return {
	"kawre/leetcode.nvim",
	cmd = "Leet",
	build = ":TSUpdate html",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
	},
	opts = {
		lang = "python3",
		picker = { provider = "snacks-picker" },
		plugins = { non_standalone = true },
	},
}
