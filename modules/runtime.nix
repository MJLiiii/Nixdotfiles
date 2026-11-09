# Compatibility for VS Code Remote-SSH, browsers, and Python extensions.
{ pkgs, ... }:
{
  programs.nix-ld.enable = true;

  # Libraries for downloaded browser binaries and Python extensions.
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    glib
    gtk3
    gdk-pixbuf
    nss
    nspr
    dbus
    dbus-glib
    at-spi2-core
    pango
    cairo
    fontconfig
    freetype
    alsa-lib
    libGL
    libdrm
    libxkbcommon
    wayland
    libX11
    libXext
    libXrender
    libXrandr
    libXcomposite
    libXdamage
    libXfixes
    libXcursor
    libXi
    libXt
    libXtst
    libxcb
  ];

  # Graphics libraries/drivers and fonts for browser rendering.
  hardware.graphics.enable = true;
  fonts.packages = with pkgs; [ dejavu_fonts ];

}
