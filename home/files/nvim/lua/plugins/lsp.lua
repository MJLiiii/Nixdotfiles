-- Language servers provided by Nix and project environments.
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "saghen/blink.cmp" },
  config = function()
    vim.lsp.config("*", {
      capabilities = require("blink.cmp").get_lsp_capabilities(),
    })
    vim.lsp.enable({ "lua_ls", "clangd", "pyright" })
    -- Optional project-specific toolchains; Lean remains managed by lean.nvim.
    if vim.fn.executable("haskell-language-server-wrapper") == 1 then
      vim.lsp.enable("hls")
    end
    if vim.fn.executable("vsrocqtop") == 1 then
      vim.lsp.enable("vsrocq")
    end
  end,
}
