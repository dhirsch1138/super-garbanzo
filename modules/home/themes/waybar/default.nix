{ config, pkgs, ... }:
{
  # All of the modules that should be imported for home-manager waybar theme configurations
  imports = [
    ./waybarThemes.nix
  ];

}
