-- Merged on top of nvim-lspconfig's lsp/lua_ls.lua (its codeLens/hint settings survive). Upstream
-- ships no Neovim awareness on purpose, so without this file every `vim` and `Snacks` in this config
-- is an undefined-global and `lean.Config` an undefined-doc-name.
local lazy_root = vim.fn.stdpath("data") .. "/lazy" -- where core/lazy.lua installs plugins
return {
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
				-- resolve require("core.options") the way Nvim does (:h lua-module-load)
				path = { "lua/?.lua", "lua/?/init.lua" },
			},
			workspace = {
				checkThirdParty = false, -- no "apply luv/love2d?" prompt
				-- Only what this config references. $VIMRUNTIME already carries `vim.*` and the `uv`
				-- class behind vim.uv (lua/uv/_meta.lua), so LuaLS's bundled ${3rd}/luv would only
				-- duplicate every definition. Not the whole runtimepath: slow, and nvim-lspconfig's
				-- own notes warn against it.
				library = {
					vim.env.VIMRUNTIME,
					lazy_root .. "/snacks.nvim", -- `Snacks` global (lua/plugins/snacks.lua)
					lazy_root .. "/lean.nvim", -- `lean.Config` type (lua/plugins/lean.lua)
				},
			},
		},
	},
}
