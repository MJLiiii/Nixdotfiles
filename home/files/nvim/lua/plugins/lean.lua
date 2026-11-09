-- Lean 4 has no server in nvim-lspconfig (only lean3ls, whose own docs point here),
-- and no mason package. lean.nvim ships its own lsp/leanls.lua and enables it from
-- plugin/lean.lua, so lua/plugins/lsp.lua needs no entry for it -- and adding one
-- would double-attach two `lake serve` processes to the same project.
return {
	"Julian/lean.nvim",
	ft = "lean",

	-- blink.cmp injects completion capabilities via vim.lsp.config("*"). lua/plugins/lsp.lua
	-- normally pulls it in at BufReadPre, but listing it here also covers `:enew` followed by
	-- `:set ft=lean`, where no BufReadPre fires.
	dependencies = { "saghen/blink.cmp" },

	init = function()
		-- Configure through vim.g.lean_config, not lazy's `opts`: the latter routes through
		-- require("lean").setup(), which is deprecated and slated for removal in v2026.9.1.
		---@type lean.Config
		vim.g.lean_config = {
			-- <LocalLeader> mappings in Lean buffers -- \i toggles the infoview, \x pins a
			-- goal, \r restarts the file -- plus K for the rich interactive hover.
			-- This is the top-level lean.Config.mappings boolean, NOT the deprecated
			-- infoview.mappings table. ftplugin/lean/lean.lua tests `== true`, so anything other
			-- than the literal true silently disables all of them.
			mappings = true,
		}
	end,
}
