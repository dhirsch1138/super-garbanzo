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
  # This wrapper includes supporting packages, and enables auto key generation and enrollment.
  # When initially deployed, the UEFI will still need to be set to Learn/Setup in the BIOS
  # so that the enrollement will be accepted.
  boot.lanzabootewrapper.enable = true;

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
}
