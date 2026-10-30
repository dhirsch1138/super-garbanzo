{ config, pkgs, ... }:
{
  # This is meant to define the packages and services that should be installed for personal desktop
  # It has developer tools, and fun stuff like steam.

  imports = [
    ./../modules/system
  ];

  # Reference the swaywm.nix support module for additional default configuration
  programs.sway.enable = true;

  # Enable secure boot support.
  # Reference the secureboot.nix support module for additional default configuration
  boot.lanzaboote.enable = true;

  # Reference the steam.nix support module for additional default configuration
  programs.steam.enable = true;

  # Enable slowflakes with supporting packages and configuration
  # Provide time delayed flake.lock updates to help avoid breakages from upstream changes
  # or supply chain issues.
  # reference: https://github.com/dhirsch1138/slowflakes
  services.slowflakes = {
    enable = true;
    delayDays = 7; # Number of days to delay flake.lock updates [7]
    enableLocalAutomation = true; # Enables the daily background systemd timer [7]
    repoPath = "/etc/nixos"; # Path to the flake repository ["/etc/nixos"]
  };

  # This is machine specific for Helios (powerspec G228)
  # TODO : move this into a module for this machine, and then import it here.
  boot.acpiFix.enableForce = true;
  boot.acpiFix.enableEnforceResourcesLax = true;

  systemd.services.run-on-shutdown = {
    description = "Run custom command on shutdown";
    wantedBy = [
      "halt.target"
      "poweroff.target"
      "reboot.target"
    ];
    before = [
      "halt.target"
      "poweroff.target"
      "reboot.target"
    ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "/bin/true";
      ExecStop = "${pkgs.util-linux}/bin/rfkill block all";
    };
  };

  systemd.services.run-on-suspend = {
    description = "Run custom command before going to sleep";
    wantedBy = [ "sleep.target" ];
    before = [ "sleep.target" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.util-linux}/bin/rfkill block all";
    };
  };

  systemd.services.run-on-resume = {
    description = "Run custom command after waking up";
    wantedBy = [ "post-resume.target" ];
    after = [ "post-resume.target" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.util-linux}/bin/rfkill unblock all";
    };
  };
}
