local map = vim.keymap.set

map("i", "jk", "<Esc>", { desc = "Exit Insert Mode" })

-- <leader>n is free again: Notification History moved to <leader>un in
-- lua/config/snacks_keymaps.lua, so <leader>nh fires without a 'timeoutlen' wait. Both this map
-- and <leader>ur clear 'hlsearch'; this one is kept for muscle memory, <leader>ur also redraws.
map("n", "<leader>nh", "<cmd>nohlsearch<cr>", { desc = "Clear Search Highlights" })

-- s* = window splits. This shadows built-in s (substitute char): s alone now waits 'timeoutlen'.
-- Use cl instead.
map("n", "sv", "<C-w>v", { desc = "Split Window Vertically" })
map("n", "sh", "<C-w>s", { desc = "Split Window Horizontally" }) -- rhs is <C-w>s; h = horizontal
map("n", "sc", "<C-w>c", { desc = "Close Window" })
map("n", "so", "<C-w>o", { desc = "Close Other Windows" })
-- turns the current window into a plain :terminal (not a snacks one: <c-/> and <c-_> do not toggle
-- it, its shell exiting leaves the window open). lua/core/autocmds.lua puts it in terminal-mode.
map("n", "st", "<cmd>terminal<cr>", { desc = "Terminal in Current Window" })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- <C-hjkl> move the cursor between windows. <C-l> replaces Nvim's built-in
-- :nohlsearch + diffupdate + redraw (:h CTRL-L-default); <leader>ur below restores it.
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window" })
map(
	"n",
	"<leader>ur",
	"<cmd>nohlsearch<bar>diffupdate<bar>normal! <C-L><cr>",
	{ desc = "Redraw / Clear Search Highlights" }
)

-- Terminal-mode, global so :terminal / st buffers get them as well as snacks terminals.
--
-- <C-hjkl> move between windows straight from terminal-mode (<cmd> does not leave the mode; Nvim
-- drops it by itself once the cursor lands in a non-terminal window). The key is handed to the job
-- instead when it could not move anywhere: in a float (lazygit binds <C-j>/<C-k>) and when there
-- is no window on that side (winnr("l") == winnr()), so <C-l> still clears the screen in the
-- right-hand terminal and <C-k> still kills to end of line in a full-height one.
for _, dir in ipairs({ "h", "j", "k", "l" }) do
	local key = "<C-" .. dir .. ">"
	map("t", key, function()
		if vim.api.nvim_win_get_config(0).relative ~= "" or vim.fn.winnr(dir) == vim.fn.winnr() then
			return key
		end
		return "<cmd>wincmd " .. dir .. "<cr>"
	end, { expr = true, desc = "Go to Window (or send key to job)" })
end

-- <Esc><Esc> within 200 ms leaves terminal-mode; a lone <Esc> reaches the job immediately (a plain
-- "<Esc><Esc>" lhs would hold every <Esc> back for 'timeoutlen'). Same timer trick as snacks'
-- buffer-local term_normal key, which keeps precedence inside snacks terminals.
local esc_timer
map("t", "<Esc>", function()
	esc_timer = esc_timer or assert(vim.uv.new_timer())
	if esc_timer:is_active() then
		esc_timer:stop()
		return "<C-\\><C-n>"
	end
	esc_timer:start(200, 0, function() end)
	return "<Esc>"
end, { expr = true, desc = "Double Escape to Normal Mode" })

-- lazy.nvim itself, not a plugin spec (<leader>sp is the *spec picker*, not the :Lazy UI)
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })
