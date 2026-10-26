{ config, pkgs, ... }:
{
  # All of the modules that should be imported for home-manager sway & waybar (for sway)configurations
  imports = [
    ./swayidle.nix
    ./sway.nix
    ./waybar.nix
  ];

}
