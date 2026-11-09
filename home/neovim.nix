# Neovim plugins use lazy.nvim; external tools are installed by Nix.
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gcc
    gnumake
    tree-sitter
    fd
    lazygit
    gh
    unzip
    lua-language-server
    clang-tools
    pyright
    stylua
    black
    isort
    rustfmt
    ormolu
    prettier
    shfmt
    taplo
    tex-fmt
    selene
    ruff
    eslint_d
    markdownlint-cli
    shellcheck
    yamllint
    vim-vint
    proselint
  ];

  xdg.configFile."nvim" = {
    source = ./files/nvim;
    # Individual files are linked so lazy-lock.json stays writable and local.
    recursive = true;
  };
}
