return {
	"saghen/blink.cmp",
	version = "1.*",
	-- no trigger of its own: lua/plugins/lsp.lua (and lean.lua) pull it in as a dependency so that
	-- its plugin/blink-cmp.lua injects LSP capabilities via vim.lsp.config("*") before any LSP
	-- client starts
	lazy = true,
	opts = {
		keymap = {
			preset = "none",

			["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
			["<C-e>"] = { "hide", "fallback" },

			["<Tab>"] = {
				-- accept() acts on the selected item only; select_and_accept() first selects item 1
				-- when nothing is selected. With blink's defaults (completion.list.selection.preselect
				-- = true, cycle.from_top/from_bottom = true, both unset here) item 1 is always
				-- selected while the menu is open, so both branches behave identically today; the
				-- snippet_active() split is kept so Tab still does the right thing if preselect is
				-- ever turned off.
				function(cmp)
					if cmp.snippet_active() then
						return cmp.accept()
					else
						return cmp.select_and_accept()
					end
				end,
				"snippet_forward",
				"fallback",
			},
			["<S-Tab>"] = { "snippet_backward", "fallback" },

			["<Up>"] = { "select_prev", "fallback" },
			["<Down>"] = { "select_next", "fallback" },
			["<C-p>"] = { "select_prev", "fallback_to_mappings" },
			["<C-n>"] = { "select_next", "fallback_to_mappings" },

			["<C-b>"] = { "scroll_documentation_up", "fallback" },
			["<C-f>"] = { "scroll_documentation_down", "fallback" },
		},
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},
		fuzzy = {
			implementation = "lua",
		},
	},
}
