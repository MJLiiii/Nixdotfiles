# Add system-wide command-line tools here.
{ pkgs, llmAgents, ... }:
let
  agents = llmAgents.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  environment.systemPackages =
    (with pkgs; [
      git
      curl
      wget
      vim
      htop
      tmux
      rsync
      jq
      ripgrep
      pciutils
      usbutils
      ethtool
      smartmontools
      docker-compose
      python3
      uv
      neovim
      rustup
      gcc
      pkg-config
      xorg-server
      nixfmt
      nixd
      ncurses
      duckdb
      iperf3
      lazygit
      llvm
      lua
      z3
      cvc5
      sqlite
      postgresql
      openjdk
      pandoc
      rocq-core
      tree-sitter
      yazi
    ])
    ++ [
      # Keep Numtide packages on their own pinned Nixpkgs for cache compatibility.
      agents.codex
      agents.opencode2
      agents.claude-code
    ];

}
