return {
	"rachartier/tiny-code-action.nvim",
	-- Explicit: tiny-code-action would otherwise autodetect telescope/fzf-lua first and only
	-- lands on snacks because neither is installed.
	opts = { picker = "snacks" },
	keys = {
		{
			"<leader>ca",
			function()
				require("tiny-code-action").code_action()
			end,
			desc = "Code Action",
			mode = { "n", "x" },
		},
	},
}
