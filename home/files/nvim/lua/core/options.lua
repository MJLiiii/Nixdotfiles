local opt = vim.opt

opt.number = true
opt.relativenumber = true

opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true -- spaces by default; this config's own .lua files are tabs (stylua rewrites them on save)

opt.cursorline = true
opt.termguicolors = true -- not a default: Nvim only auto-enables it when the terminal advertises support
opt.signcolumn = "yes" -- always reserved, so diagnostics never shift the text
opt.showmode = false -- mini.statusline already shows the mode
opt.winborder = "rounded" -- one border for LSP hover/signature, the diagnostic float and the blink menu

opt.splitright = true
opt.splitbelow = true

-- 0.12 defaults leave virtual_text and severity_sort off, so diagnostic text is invisible
-- until you jump to it or open the float. ]d/[d/]D/[D are already defaults; no nav maps needed.
-- Virtual text is single-line and never wraps, so a multi-line message (HLS does this a lot)
-- runs off the right edge. Inline, show only its first line; on the cursor line hand over to
-- virtual_lines, which renders the whole message below the line with wrapping.
vim.diagnostic.config({
	severity_sort = true,
	virtual_text = {
		spacing = 2,
		prefix = "●",
		current_line = false, -- everywhere except the cursor line (virtual_lines covers that)
		format = function(d)
			return d.message:match("^[^\n]*")
		end,
	},
	virtual_lines = { current_line = true },
	float = { source = true },
})
