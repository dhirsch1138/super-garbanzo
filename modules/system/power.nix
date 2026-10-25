{ config, pkgs, ... }:
{

  # Enables toggling of power profiles
  services.power-profiles-daemon.enable = true;

  # Thermald proactively prevents overheating on Intel CPUs and works well with other tools.
  services.thermald.enable = true;

  # TODO add module to enable TLP

}
