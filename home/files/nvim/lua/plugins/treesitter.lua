-- nvim-treesitter's master branch does not support Neovim 0.12, so this is the main
-- branch: no configs.setup(), no ensure_installed, and highlighting is opt-in.
-- Upstream states the plugin does not support lazy-loading, hence lazy = false.
--
-- Requires the tree-sitter CLI (>= 0.26.1) on PATH: brew install tree-sitter-cli
-- (the plain `tree-sitter` formula is the library only and ships no binary).
return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").install({
			-- the languages this config has LSP servers for
			"c",
			"cpp",
			"python",
			"haskell",
			"lua",
			-- leetcode.nvim uses this to format question descriptions
			"html",
			-- Neovim bundles parsers for these, but nvim-treesitter ships its own queries
			-- for them too. Its queries sit earlier on 'runtimepath' than $VIMRUNTIME, so
			-- they would be run against Neovim's older bundled parsers. Installing them
			-- here keeps parser and queries in step.
			"markdown",
			"markdown_inline",
			"query",
			"vim",
			"vimdoc",
		})

		-- Highlighting is not automatic on the main branch. Start it per buffer, but only
		-- when a parser actually exists: language.add() returns nil (never throws) for a
		-- missing parser, so coq and lean quietly keep their regex syntax. (0.12's own
		-- ftplugins already call vim.treesitter.start() for lua, markdown, query and help;
		-- a second call on the same tree returns the existing highlighter, see
		-- vim.treesitter.highlighter.new.)
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
			callback = function(args)
				local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
				if lang and vim.treesitter.language.add(lang) then
					vim.treesitter.start(args.buf, lang)
				end
			end,
		})
	end,
}
