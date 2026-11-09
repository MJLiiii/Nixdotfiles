{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.nodejs_24 ];

  # Pair once as mjli before enabling this service. The agent reuses
  # credentials saved under /home/mjli/.desktop-commander-device/.
  systemd.services.desktop-commander = {
    description = "Remote Desktop Commander";
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    startLimitIntervalSec = 0;

    path = [
      pkgs.nodejs_24
      pkgs.bash
      pkgs.coreutils
    ];
    environment.HOME = "/home/mjli";

    serviceConfig = {
      Type = "simple";
      User = "mjli";
      WorkingDirectory = "/home/mjli";
      Restart = "always";
      RestartSec = "15s";
      TimeoutStopSec = "30s";
    };

    # Include installed system/user tools for commands run by the agent.
    # @latest is resolved by npm at startup, independently of flake.lock.
    script = ''
      export PATH="/run/wrappers/bin:/run/current-system/sw/bin:/home/mjli/.nix-profile/bin:$PATH"
      exec ${pkgs.nodejs_24}/bin/npx --yes @wonderwhy-er/desktop-commander@latest remote
    '';
  };
}
