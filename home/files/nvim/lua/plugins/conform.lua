-- Tools are installed by Nix, not Mason.
local prettier = { "prettierd", "prettier", stop_after_first = true }

return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	cmd = "ConformInfo",
	keys = {
		{
			"<leader>cf",
			function()
				-- range comes from a charwise/linewise visual selection; visual-block formats the buffer
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			mode = { "n", "x" },
			desc = "Format Buffer / Selection",
		},
	},
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "isort", "black" },
			rust = { "rustfmt" }, -- ships with rustup, not mason
			-- hls formats through its bundled ormolu as well (lsp_format = "fallback" below), but only
			-- once it has finished initialising; the standalone binary is instant and the same
			-- formatter. lhaskell is left to hls: ormolu cannot read literate Haskell. lean and coq
			-- have no formatter in conform (or anywhere else), so they stay LSP-fallback only.
			haskell = { "ormolu" },
			c = { "clang-format" },
			cpp = { "clang-format" },
			objc = { "clang-format" },
			objcpp = { "clang-format" },

			javascript = prettier,
			html = prettier,
			css = prettier,
			json = prettier,
			yaml = prettier,
			markdown = prettier,

			sh = { "shfmt" },
			bash = { "shfmt" },
			zsh = { "shfmt" },
			toml = { "taplo" },
			tex = { "tex-fmt" },
		},
		format_on_save = {
			-- passed through to conform.format()
			timeout_ms = 500,
			lsp_format = "fallback",
		},
	},
}
