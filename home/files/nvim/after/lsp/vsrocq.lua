-- Merged on top of nvim-lspconfig's lsp/vsrocq.lua, which already supplies
-- cmd = { "vsrocqtop" }, filetypes = { "coq" } and the root markers
-- { "_RocqProject", "_CoqProject", ".git" }. Only server options are added here.
--
-- vsrocqtop ships NO built-in defaults: it configures itself entirely from
-- "initializationOptions", decoded as one complete record (protocol/settings.ml).
-- A partial table makes the decoder raise, lspManager.ml swallows the exception, and
-- the server then never answers "initialize" -- the client silently never attaches.
-- Every field below must stay present; dropping proof.workers alone is enough to kill it.
--
-- vsrocqtop also sends workspace/configuration and discards the reply, so a `settings`
-- table would have no effect.
return {
	init_options = {
		proof = {
			-- 1 = Continuous: check the whole buffer and publish diagnostics. The default
			-- 0 (Manual) checks nothing until the editor sends VsRocq's custom prover/*
			-- stepping requests, which Neovim does not, so it yields zero diagnostics.
			mode = 1,
			-- Keep checking past the first error so the whole file is diagnosed.
			block = false,
			delegation = "None",
			workers = 1,
			pointInterpretationMode = 0,
		},
		goals = { diff = { mode = "off" }, messages = { full = true }, ppmode = "Pp" },
		-- VsRocq's completion is experimental and returns nothing in practice: tested at
		-- tactic and term positions in a fully-checked buffer, with this flag both true
		-- and false, and textDocument/completion came back with 0 items every time.
		-- Left off so nothing pretends to work; Rocq buffers fall back to blink.cmp's
		-- buffer/snippet sources. Flip to true if a future vsrocqtop implements it.
		completion = { enable = false, algorithm = 1, unificationLimit = 100 },
		diagnostics = { enable = true, full = false },
		-- Gigabytes before vsrocqtop restarts itself.
		memory = { limit = 4 },
	},
}
