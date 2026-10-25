{ config, pkgs, ... }:
{
  # All of the modules that should be imported for system configurations
  imports = [
    ./acpi-fix.nix
    ./audio.nix
    ./bluetooth.nix
    ./fonts.nix
    ./graphics.nix
    ./nix-collect-garbage.nix
    ./nixsystem.nix
    ./plymouth.nix
    ./power.nix
    ./secureboot.nix
    ./security.nix
    ./steam.nix
    ./swap.nix
    ./swaywm.nix
    ./tuigreet.nix
    ./usbdrives.nix
  ];

}
