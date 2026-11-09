-- Keep the selected HLS on PATH first, and expose backends from other installed
-- GHCup releases for projects using older/newer GHC versions.
local hls_bins = vim.fn.glob(vim.fn.expand("~") .. "/.ghcup/hls/*/bin", false, true)

return {
	cmd = function(dispatchers, config)
		local env = vim.tbl_extend("force", {}, config.cmd_env or {})
		if #hls_bins > 0 then
			env.PATH = (env.PATH or vim.env.PATH or "") .. ":" .. table.concat(hls_bins, ":")
		end
		return vim.lsp.rpc.start({ "haskell-language-server-wrapper", "--lsp" }, dispatchers, {
			cwd = config.root_dir,
			env = env,
			detached = config.detached,
		})
	end,
}
