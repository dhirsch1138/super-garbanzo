{ config, pkgs, ...}:
{

  imports =
    [
      ./system/audio.nix
      ./system/bluetooth.nix
      ./system/fonts.nix
      ./system/graphics.nix
      ./system/nix-collect-garbage.nix
      ./system/nixsystem.nix
      ./system/plymouth.nix
      ./system/power.nix
      ./system/steam.nix
      ./system/swap.nix
      ./system/swaywm.nix
      ./system/tuigreet.nix
      ./system/usbdrives.nix
    ];

}
