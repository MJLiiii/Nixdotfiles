-- Load order matters:
--   mapleader / maplocalleader must be set before any <leader> / <LocalLeader> mapping is
--   defined (the leader is expanded at the moment a mapping is created, see :h mapleader);
--   core.lazy bootstraps lazy.nvim and imports every spec under lua/plugins/.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\" -- Nvim's default, stated explicitly: lean.nvim binds <LocalLeader>i/x/r and more

require("core.options")
require("core.keymaps")
require("core.autocmds")
require("core.lazy")
