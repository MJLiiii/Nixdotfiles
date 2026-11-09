{ pkgs, ... }:
{
  imports = [ ./desktop-commander.nix ];

  # Containers and virtual machines
  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;

  # PostgreSQL is available only on localhost.
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_18;
    settings.listen_addresses = "localhost";
  };

  systemd.tmpfiles.rules = [
    "d /srv/agents 0750 mjli users - -"
    "d /srv/containers 0750 mjli users - -"
    "d /srv/vms 0750 mjli users - -"
  ];

}
