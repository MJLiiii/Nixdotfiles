# Neovim

Neovim 0.12 config managed by [lazy.nvim](https://github.com/folke/lazy.nvim). Installed plugin
revisions are pinned in a local `lazy-lock.json`, which is intentionally untracked; each machine
maintains its own lockfile.

## Requirements

Nix installs language servers, formatters, and linters from `../../neovim.nix`.
Mason is disabled in this NixOS configuration. Add tools to that file and rebuild.
Lua, C/C++, and Python LSPs are enabled in `lua/plugins/lsp.lua`. Haskell and Rocq
are enabled when their tools are on PATH; Lean uses the project's `lake` tool.
Provide these optional toolchains through your project environment.

Edit the files in this repository, then run `./rebuild switch` from the repository
root to update the Home Manager links. Do not edit the generated files in
`~/.config/nvim` directly.

## Layout

| Path | Contents |
|---|---|
| `init.lua` | Leader keys, then `core.options` → `core.keymaps` → `core.autocmds` → `core.lazy` |
| `lua/core/` | Editor options, global keymaps and autocmds, and the lazy.nvim bootstrap |
| `lua/plugins/` | One main lazy.nvim spec per plugin; a plugin's keymaps normally live in its spec |
| `lua/config/` | Larger plugin-specific configuration tables, such as the Snacks keymap catalog |
| `after/lsp/<server>.lua` | Per-server overrides, deep-merged on top of nvim-lspconfig's defaults |
| `Makefile` | Formatting, linting and headless startup checks |

## Development

Run the following commands from this directory:

| Command | Purpose |
|---|---|
| `make format` | Format all Lua files with StyLua |
| `make format-check` | Check formatting without modifying files |
| `make lint` | Lint Lua files with Selene |
| `make smoke` | Load the full config in headless Neovim |
| `make check` | Run the format check, lint and startup smoke test |

The Makefile uses the Nix-provided `stylua` and `selene` on `PATH`.
Override `NVIM`, `STYLUA` or `SELENE` when using different binaries. Formatting follows `.stylua.toml` (tabs, 120 columns); linting follows `selene.toml` and
`vim.yml`.

When linting inside Neovim, `lua/plugins/lint.lua` locates the nearest `selene.toml` above the
current buffer and passes it explicitly, so editing this config from another working directory does
not silently discard the Selene settings.

## Editing conventions

- Use English for comments, documentation, names and keymap descriptions.
- Keep plugin-specific setup and small keymap groups with the owning plugin spec. Use `lua/config/`
  only when a large configuration table benefits from its own module.
- Prefer `opts` when a plugin exposes a conventional `setup()` function. Use `config` for direct
  assignment or multi-step initialization.
- Preserve `event`, `ft`, `cmd`, `lazy` and `priority` values when reorganizing a spec.
- Add LSP servers to `vim.lsp.enable` in `lua/plugins/lsp.lua` and their packages to
  `../../neovim.nix`. Put server-specific overrides in `after/lsp/`.
- Add formatters and linters to `conform.lua` and `lint.lua`, with their packages in
  `../../neovim.nix`.

## Keymap prefixes

`<leader>` is Space, `<LocalLeader>` is `\`. For the configured mini.clue triggers, pause 300 ms
after a prefix to open the hint window. The bare `g` and `s` prefixes are intentionally excluded;
leader mappings are still covered. `<leader>sk` lists every mapping with its description.

| Prefix | Group |
|---|---|
| `<leader>f` | Find files / buffers / recent |
| `<leader>s` | Search or list anything (Snacks pickers) |
| `<leader>g` | Git and GitHub |
| `<leader>c` | Code: action, format, symbols, call hierarchy |
| `<leader>x` | Trouble lists |
| `<leader>u` | UI toggles, notifications, colorschemes |
| `g*` | LSP navigation (`gd`, `gD`, `gr`, `gI`, `gy`) |
| `s*` | Window splits (`sv`, `sh`, `sc`, `so`); `st` turns the window into a `:terminal` |
| `<C-hjkl>` | Window focus, from terminal-mode too; `<C-arrows>` resize |
| `<C-/>` / `<C-_>` | Toggle the right / bottom terminal; `<Esc><Esc>` leaves terminal-mode |
| `<LocalLeader>` | lean.nvim in Lean buffers |

Distinct `<C-/>` and `<C-_>` shortcuts require a terminal that encodes them separately, such as one
using the kitty keyboard protocol. Otherwise Ctrl+/ commonly arrives as `<C-_>` and toggles the
bottom terminal.
