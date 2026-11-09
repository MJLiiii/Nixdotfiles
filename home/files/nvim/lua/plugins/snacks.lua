-- Fuzzy pickers, file explorer, notifier, indent guides, scope, smooth scroll, lazygit and
-- terminal (snacks.nvim). The keymap catalog lives in lua/config/snacks_keymaps.lua.
return {
	"folke/snacks.nvim",
	lazy = false,
	priority = 1000,
	keys = require("config.snacks_keymaps"),
	opts = {
		-- Presence of a key enables the module (`words = {}` would turn words ON), so every entry
		-- keeps its explicit `enabled` flag.
		bigfile = { enabled = true },
		explorer = { enabled = true },
		indent = { enabled = true },
		input = { enabled = true },
		picker = { enabled = true },
		notifier = { enabled = true },
		quickfile = { enabled = true },
		scope = { enabled = true },
		scroll = { enabled = true },
		words = { enabled = false }, -- default; kept explicit so it reads as a choice
		-- Snacks.lazygit() / Snacks.terminal() are on-demand APIs, not setup modules: they need
		-- no opts entry and their `enabled` flag is ignored. Their keymaps are in the catalog.
	},
	-- Explicit config() replaces lazy's implicit require("snacks").setup(opts) with the
	-- identical call; needed because Snacks.toggle only exists after setup has run.
	config = function(_, opts)
		require("snacks").setup(opts)
		Snacks.toggle.diagnostics():map("<leader>ud")
		Snacks.toggle.inlay_hints():map("<leader>uh")
	end,
}
