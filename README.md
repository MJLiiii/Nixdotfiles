# Nixdotfiles

NixOS 26.05 configuration for `ms02`, with Home Manager for `mjli`.
Edit this repository as your normal user. One rebuild applies both system and
personal settings; only activation uses `sudo`.

## Where to edit

| Change | File |
| --- | --- |
| Machine name, networking, SSH access, user, boot settings | `hosts/ms02/configuration.nix` |
| SSH public keys | `hosts/ms02/authorized_keys` |
| System packages, Codex, OpenCode | `modules/packages.nix` |
| Docker, virtual machines, PostgreSQL, service directories | `modules/services.nix` |
| Remote Desktop Commander | `modules/desktop-commander.nix` |
| VS Code/browser compatibility libraries, graphics, fonts | `modules/runtime.nix` |
| Nix features, binary caches, garbage collection | `modules/nix.nix` |
| Personal settings and SSH client configuration | `home/default.nix` |
| Neovim language servers, formatters, linters | `home/neovim.nix` |
| Git and Vim settings | `home/files/gitconfig`, `home/files/vimrc` |
| Neovim options, keymaps, plugins | `home/files/nvim/` |
| Dependency sources and host wiring | `flake.nix` |

`hosts/ms02/hardware-configuration.nix` is the generated hardware configuration.
`hosts/ms02/disko.nix` describes the existing disk layout. Keep those files unless
intentionally changing the machine or reinstalling it. Normal rebuilds do not
format disks.

## Edit and apply

```bash
cd ~/Nixdotfiles
# Edit the appropriate files in your editor.
# Stage newly created files so Nix can see them:
git add <new-file>

./rebuild          # Build only; no sudo and no activation.
./rebuild switch   # Build and apply; uses sudo only for privileged operations.
```

The helper also accepts `test` (apply until the next boot) and `boot` (apply on the
next boot). It locates this repository even when invoked from another directory.
Home Manager runs as part of the system rebuild; no separate `home-manager switch`
command is needed.

The equivalent standard commands are:

```bash
nixos-rebuild build --flake ~/Nixdotfiles#ms02
nixos-rebuild switch --flake ~/Nixdotfiles#ms02 --sudo
```

Nothing needs to be copied back to `/etc/nixos`. Always use this flake path or the
helper: a bare `sudo nixos-rebuild switch` still reads the old `/etc/nixos` copy.

Edit the source files here, then rebuild. Home Manager creates read-only links for
managed files in your home directory. Neovim's `lazy-lock.json` stays writable and
machine-local; lazy.nvim still manages its plugins.

## Add a package

Add a normal Nixpkgs package to the first list in `modules/packages.nix`. Add an
LLM agent to its second list, for example `agents.opencode` (already included).
Neovim tools belong in `home/neovim.nix`.

Codex and OpenCode use `numtide/llm-agents.nix` and the Numtide binary cache. Keep
that input's own Nixpkgs pin; overriding it can prevent use of cached builds.

## Update versions deliberately

The lockfile pins the dependencies. Ordinary rebuilds reuse those versions.
From this directory:

```bash
nix flake update llm-agents       # Update the LLM agent input.
# Or, when you want to update the system and Home Manager inputs:
nix flake update nixpkgs home-manager
./rebuild
./rebuild switch
```

Review and commit `flake.lock` with your configuration changes. Keep
`system.stateVersion` and `home.stateVersion` at `26.05`; they describe the original
installation and are not package-version selectors.

## Check and save changes

```bash
nix flake check --no-build
nix fmt flake.nix hosts/ms02/*.nix modules/*.nix home/*.nix
./rebuild

git add <changed-files>
git commit -m "Describe the configuration change"
git push origin main
```

To undo an applied generation, use `sudo nixos-rebuild switch --rollback`.
Revert the corresponding source change with Git before the next rebuild.

## Format Nix in VS Code

The NixIDE extension (`jnoortheen.nix-ide`) runs in the VS Code Remote-SSH
extension host. The workspace settings in `.vscode/settings.json` enable the
`nixd` language server and format Nix files with `nixfmt` on save. `nixd` and
`nixfmt` are installed by `modules/packages.nix`, so rebuild after changing that
file.

- Format the current file: `Shift+Alt+F` (or **Format Document** from the
  Command Palette).
- To disable format-on-save, remove `editor.formatOnSave` from the `[nix]`
  section.
- The editor and `nix fmt` both use `nixfmt`, so their output matches.

## Migration

This repository was assembled from the working `/etc/nixos` configuration on
2026-11-09, preserving package pins, storage, networking, services, SSH access,
and the Home Manager integration. The old configuration remains available there;
a separate timestamped copy is under `~/.local/state/nixdotfiles/backups/`.

Git, Vim, and Neovim settings were copied from `MJLiiii/dotfiles` at
`ac7676ca36fcebe152bf605edcb3c81d853c899a`, including the already-applied NixOS
Neovim adaptations. This repository now owns these Linux settings directly; it
does not fetch or patch the other dotfiles repository during builds.

The unused `nixpkgs-unstable` input and old `codex-bin.nix` fallback were omitted.
Private SSH keys, application credentials, and Desktop Commander pairing data
remain in their existing locations outside this repository.
