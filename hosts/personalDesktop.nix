{ config, pkgs, ... }:
{
  # This is meant to define the packages and services that should be installed for personal desktop
  # It has developer tools, and fun stuff like steam.
 
  imports = [
    ./../modules/default_system.nix
  ];

  programs.steamwrapper.enable = true;

  services.slowflakes = {
    enable = true;
    delayDays = 7;                       # Number of days to delay flake.lock updates [7]
    enableLocalAutomation = true;        # Enables the daily background systemd timer [7]
    repoPath = "/etc/nixos";             # Absolute path to your primary repo [7]
  };

  boot.acpiFix.enableForce = true;
  boot.acpiFix.enableEnforceResourcesLax = true;

  boot.lanzabootewrapper.enable = true;

}
