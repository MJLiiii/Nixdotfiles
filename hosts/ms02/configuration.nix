# Machine-specific settings for the ms02 development server.
{ lib, ... }:
let
  # This file contains public keys only.
  sshKeys = builtins.filter (line: line != "" && !(lib.hasPrefix "#" line)) (
    lib.splitString "\n" (builtins.readFile ./authorized_keys)
  );
in
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ../../modules/nix.nix
    ../../modules/packages.nix
    ../../modules/runtime.nix
    ../../modules/services.nix
  ];

  assertions = [
    {
      assertion = sshKeys != [ ];
      message = "Populate authorized_keys with your SSH PUBLIC key before installation.";
    }
  ];

  # Host settings
  networking.hostName = "ms02";
  time.timeZone = "Etc/UTC";
  i18n.defaultLocale = "en_US.UTF-8";

  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 5;
    };
    efi.canTouchEfiVariables = true;
  };

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;
  services.fstrim.enable = true;

  # Match the actual in-use Intel I226-V NIC by MAC, not interface name.
  networking.useDHCP = false;
  systemd.network.enable = true;
  services.resolved.enable = true; # Use DNS servers learned via DHCP/RA.
  systemd.network.networks."10-wired" = {
    matchConfig.MACAddress = "38:05:25:36:31:70";
    networkConfig = {
      DHCP = "ipv4";
      IPv6AcceptRA = true;
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
  };

  environment.sessionVariables = {
    COLORTERM = "truecolor";
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AcceptEnv = [ "COLORTERM" "TERM" ];
    };
  };

  users.users.mjli = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "wheel"
      "docker"
      "libvirtd"
    ];
    openssh.authorizedKeys.keys = sshKeys;
    linger = true; # Start user services without an interactive login.
  };

  # Key-only SSH access; wheel can administer without a local password.
  # Review this choice before putting the server on an untrusted network.
  security.sudo.wheelNeedsPassword = false;

  # Keep the release used at first installation.
  system.stateVersion = "26.05";
}
