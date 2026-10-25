{ config, pkgs, ... }:
{
  # All of the modules that should be imported for home-manager configurations
  imports = [
    ./home/swayidle.nix
    ./home/sway.nix
    ./home/vscode.nix
    ./home/waybar.nix
    ./home/themes/waybar/waybarThemes.nix
    ./home/themes/swayThemes.nix
  ];

}
