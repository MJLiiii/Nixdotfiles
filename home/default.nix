# Personal settings for mjli; applied with the NixOS rebuild.
{ ... }:
{
  imports = [ ./neovim.nix ];

  home.username = "mjli";
  home.homeDirectory = "/home/mjli";
  home.stateVersion = "26.05";

  home.file.".gitconfig".source = ./files/gitconfig;
  home.file.".vimrc".source = ./files/vimrc;

  # Reference the existing private key; never copy it into this repository.
  home.file.".ssh/config".text = ''
    Host github.com
      HostName github.com
      User git
      IdentityFile ~/.ssh/id_ed25519
      IdentitiesOnly yes
  '';

  xdg.enable = true;
}
