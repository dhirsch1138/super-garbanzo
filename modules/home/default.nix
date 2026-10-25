{ config, pkgs, ... }:
{
  # All of the modules that should be imported for home-manager configurations
  imports = [
    ./swayidle.nix
    ./sway.nix
    ./vscode.nix
    ./waybar.nix
    ./themes/waybar/waybarThemes.nix
    ./themes/swayThemes.nix
  ];

}
