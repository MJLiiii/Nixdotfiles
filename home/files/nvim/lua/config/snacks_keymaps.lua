-- Keymaps for snacks.nvim. Every picker map calls one Snacks.picker source, optionally with
-- options. Index Snacks.picker[source] inside the closure: the Snacks global only exists after
-- snacks.nvim has loaded, while lazy parses this module before that. Snacks stores the options
-- table on the picker and writes toggle state back into it on close, so each press needs a copy.
---@param source string name of a Snacks.picker source, e.g. "files"
---@param opts? table picker options
local function pick(source, opts)
	return function()
		Snacks.picker[source](opts and vim.deepcopy(opts) or nil)
	end
end

return {
	-- Top level: single-key shortcuts for the most-used pickers. buffers / grep /
	-- command_history are also bound under <leader>f / <leader>s below as the discoverable
	-- spelling; both stay. (files, gh_issue and gh_pr also appear twice further down, but
	-- with different options -- those are not aliases.)
	{ "<leader><space>", pick("smart"), desc = "Smart Find Files" },
	{ "<leader>,", pick("buffers"), desc = "Buffers" },
	{ "<leader>/", pick("grep"), desc = "Grep" },
	{ "<leader>:", pick("command_history"), desc = "Command History" },
	{
		"<leader>e",
		function()
			Snacks.explorer()
		end,
		desc = "File Explorer",
	},

	-- <leader>c  code (also: ca tiny-code-action, cs/cl trouble, cf conform). Moved here from
	-- gai/gao so built-in ga (print char value) fires instantly.
	{ "<leader>ci", pick("lsp_incoming_calls"), desc = "Incoming Calls" },
	{ "<leader>co", pick("lsp_outgoing_calls"), desc = "Outgoing Calls" },

	-- <leader>f  find files
	{ "<leader>fb", pick("buffers"), desc = "Buffers" },
	{ "<leader>fc", pick("files", { cwd = vim.fn.stdpath("config") }), desc = "Find Config File" },
	{ "<leader>ff", pick("files"), desc = "Find Files" },
	{ "<leader>fg", pick("git_files"), desc = "Find Git Files" },
	{ "<leader>fp", pick("projects"), desc = "Projects" },
	{ "<leader>fr", pick("recent"), desc = "Recent" },

	-- <leader>g  git + gh (gi/gp need the gh CLI, gg needs lazygit)
	{ "<leader>gb", pick("git_branches"), desc = "Git Branches" },
	{ "<leader>gd", pick("git_diff"), desc = "Git Diff (Hunks)" },
	{ "<leader>gf", pick("git_log_file"), desc = "Git Log File" },
	{
		"<leader>gg",
		function()
			Snacks.lazygit()
		end,
		desc = "Lazygit",
	},
	{ "<leader>gl", pick("git_log"), desc = "Git Log" },
	{ "<leader>gL", pick("git_log_line"), desc = "Git Log Line" },
	{ "<leader>gs", pick("git_status"), desc = "Git Status" },
	{ "<leader>gS", pick("git_stash"), desc = "Git Stash" },
	{ "<leader>gi", pick("gh_issue"), desc = "GitHub Issues (open)" },
	{ "<leader>gI", pick("gh_issue", { state = "all" }), desc = "GitHub Issues (all)" },
	{ "<leader>gp", pick("gh_pr"), desc = "GitHub Pull Requests (open)" },
	{ "<leader>gP", pick("gh_pr", { state = "all" }), desc = "GitHub Pull Requests (all)" },

	-- <leader>s  search / list anything, letters first then punctuation (trouble.lua keeps
	-- persistent versions of sd/sD/sl/sq/ss under <leader>x* / <leader>cs)
	{ "<leader>sa", pick("autocmds"), desc = "Autocmds" },
	{ "<leader>sb", pick("lines"), desc = "Buffer Lines" },
	{ "<leader>sB", pick("grep_buffers"), desc = "Grep Open Buffers" },
	{ "<leader>sc", pick("command_history"), desc = "Command History" },
	{ "<leader>sC", pick("commands"), desc = "Commands" },
	{ "<leader>sd", pick("diagnostics"), desc = "Diagnostics" },
	{ "<leader>sD", pick("diagnostics_buffer"), desc = "Buffer Diagnostics" },
	{ "<leader>sg", pick("grep"), desc = "Grep" },
	{ "<leader>sh", pick("help"), desc = "Help Pages" },
	{ "<leader>sH", pick("highlights"), desc = "Highlights" },
	{ "<leader>si", pick("icons"), desc = "Icons" },
	{ "<leader>sj", pick("jumps"), desc = "Jumps" },
	{ "<leader>sk", pick("keymaps"), desc = "Keymaps" },
	{ "<leader>sl", pick("loclist"), desc = "Location List" },
	{ "<leader>sm", pick("marks"), desc = "Marks" },
	{ "<leader>sM", pick("man"), desc = "Man Pages" },
	{ "<leader>sp", pick("lazy"), desc = "Search for Plugin Spec" },
	{ "<leader>sq", pick("qflist"), desc = "Quickfix List" },
	{ "<leader>sR", pick("resume"), desc = "Resume" },
	{ "<leader>ss", pick("lsp_symbols"), desc = "LSP Symbols" },
	{ "<leader>sS", pick("lsp_workspace_symbols"), desc = "LSP Workspace Symbols" },
	{ "<leader>su", pick("undo"), desc = "Undo History" },
	{ "<leader>sw", pick("grep_word"), desc = "Visual Selection or Word", mode = { "n", "x" } },
	{ '<leader>s"', pick("registers"), desc = "Registers" },
	{ "<leader>s/", pick("search_history"), desc = "Search History" },

	-- <leader>u  ui (<leader>ud / <leader>uh are created in lua/plugins/snacks.lua;
	-- <leader>ur is in lua/core/keymaps.lua)
	{ "<leader>uC", pick("colorschemes"), desc = "Colorschemes" },
	{
		"<leader>un", -- was <leader>n, which made <leader>nh wait 'timeoutlen'
		function()
			Snacks.notifier.show_history()
		end,
		desc = "Notification History",
	},

	-- g...  lsp navigation. These deliberately shadow built-in commands (invisible in :nmap,
	-- since the built-ins are commands, not mappings): gd/gD (:h gd, :h gD), gr (:h gr,
	-- virtual replace) and gI (:h gI); gy shadows nothing. K is not mapped here on purpose --
	-- Nvim sets it buffer-locally on LspAttach. gr is also a prefix of Nvim 0.12's default
	-- gr* LSP maps (:h grr), so bare gr waits 'timeoutlen'; rebind if that ever annoys.
	{ "gd", pick("lsp_definitions"), desc = "Goto Definition" },
	{ "gD", pick("lsp_declarations"), desc = "Goto Declaration" },
	{ "gr", pick("lsp_references"), desc = "References" },
	{ "gI", pick("lsp_implementations"), desc = "Goto Implementation" },
	{ "gy", pick("lsp_type_definitions"), desc = "Goto Type Definition" },

	-- Unprefixed: terminals. mode "t" as well: snacks opens the terminal in terminal-mode (its
	-- interactive default) and lazy's keys are normal-mode only unless told otherwise, so the key that
	-- opened the window could not hide it. toggle() hides the window but keeps the buffer and shell;
	-- it re-derives the terminal id from v:count1 and getcwd(0) exactly like the normal-mode press.
	--
	-- <c-/> and <c-_> are two independent shells, docked right and bottom. The id is built from
	-- cmd, cwd, env and count only (snacks/terminal.lua M.tid) -- win.position is not part of it,
	-- so without something else differing both keys would toggle one and the same terminal. The
	-- env entry is that difference; its only side effect is $NVIM_TERM_DOCK in the right-hand shell.
	--
	-- Only a terminal speaking the kitty keyboard protocol tells the two keys apart. Anywhere else
	-- (tmux without extended-keys included) Ctrl+/ arrives as 0x1f = <c-_>, so it opens the bottom
	-- terminal and <c-/> cannot be typed at all.
	{
		"<c-/>",
		function()
			Snacks.terminal.toggle(nil, { env = { NVIM_TERM_DOCK = "right" }, win = { position = "right" } })
		end,
		mode = { "n", "t" },
		desc = "Toggle Terminal (Right)",
	},
	{
		"<c-_>",
		function()
			Snacks.terminal.toggle()
		end,
		mode = { "n", "t" },
		desc = "Toggle Terminal (Bottom)",
	},
}
