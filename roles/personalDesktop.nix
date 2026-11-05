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

  # This is machine specific for Helios (powerspec G228)
  # TODO : move this into a module for this machine, and then import it here.
  boot.acpiFix.enableForce = true;
  boot.acpiFix.enableEnforceResourcesLax = true;

}
