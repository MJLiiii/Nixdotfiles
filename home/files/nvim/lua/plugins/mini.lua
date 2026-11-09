return {
	"nvim-mini/mini.nvim",
	version = "*",
	lazy = false,
	-- `config`, not `opts`: lua/mini/init.lua has no setup(); each module is set up on its own.
	config = function()
		require("mini.statusline").setup() -- why options.lua sets showmode = false
		require("mini.icons").setup() -- also supplies file icons to snacks' pickers
		require("mini.pairs").setup()
		-- redundant with Nvim 0.12's built-in gc/gcc/gc-textobject (vim._comment is
		-- treesitter-aware too); kept for mini's hooks / pad options should they be wanted
		require("mini.comment").setup()
		-- mini.tabline deliberately off: buffers are reached via <leader>, and <leader>fb

		-- Key-hint window. Triggers deliberately exclude `g` and `s`: mini.clue waits
		-- indefinitely on a key that is both a mapping and a prefix (gr, ga, s), which would be
		-- worse than today's 'timeoutlen' wait. All triggers are off while recording a macro,
		-- and mini.clue maps @ and Q globally so replaying one runs with triggers off too.
		-- Triggers themselves are buffer-local mappings (created on BufWinEnter/LspAttach for
		-- listed buffers), so they never show in :nmap without a buffer argument.
		local clue = require("mini.clue")
		clue.setup({
			triggers = {
				{ mode = "n", keys = "<Leader>" },
				{ mode = "x", keys = "<Leader>" },
				{ mode = "n", keys = "z" },
				{ mode = "n", keys = "[" },
				{ mode = "n", keys = "]" },
				{ mode = "n", keys = '"' },
				{ mode = "n", keys = "'" },
				{ mode = "n", keys = "`" },
				{ mode = "i", keys = "<C-x>" },
			},
			clues = {
				clue.gen_clues.builtin_completion(),
				clue.gen_clues.marks(),
				clue.gen_clues.registers(),
				clue.gen_clues.square_brackets(),
				clue.gen_clues.z(),
				{ mode = "n", keys = "<Leader>c", desc = "+Code" },
				{ mode = "n", keys = "<Leader>f", desc = "+Find" },
				{ mode = "n", keys = "<Leader>g", desc = "+Git / GitHub" },
				{ mode = "n", keys = "<Leader>n", desc = "+Search Highlights" },
				{ mode = "n", keys = "<Leader>s", desc = "+Search" },
				{ mode = "n", keys = "<Leader>u", desc = "+UI" },
				{ mode = "n", keys = "<Leader>x", desc = "+Trouble" },
				{ mode = "x", keys = "<Leader>c", desc = "+Code" },
				{ mode = "x", keys = "<Leader>s", desc = "+Search" },
			},
			window = { delay = 300 },
		})
	end,
}
