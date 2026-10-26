{ config, pkgs, ... }:
{
  # All of the modules that should be imported for home-manager theme configurations
  imports = [
    ./swayThemes.nix
    ./waybar
  ];

}
