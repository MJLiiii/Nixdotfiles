-- Plain :terminal buffers (st in lua/core/keymaps.lua) behave like snacks terminals: terminal-mode
-- as soon as they open and again every time the buffer is re-entered. Snacks terminals are skipped,
-- snacks does the same for them itself (start_insert / auto_insert) and b:snacks_terminal is set
-- before their job starts. The current-buffer check keeps a terminal that some plugin opens in the
-- background from putting whatever buffer you are editing into insert-mode.
vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter" }, {
	group = vim.api.nvim_create_augroup("user_terminal", { clear = true }),
	pattern = "term://*",
	callback = function(ev)
		if vim.b[ev.buf].snacks_terminal == nil and vim.api.nvim_get_current_buf() == ev.buf then
			vim.cmd.startinsert()
		end
	end,
})
