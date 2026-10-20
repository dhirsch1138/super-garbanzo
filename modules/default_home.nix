{ config, pkgs, ... }:
{

  imports = [
    # Unconditionally include the home modules
    ./home/swayidle.nix
    ./home/sway.nix
    ./home/waybar.nix
    ./home/themes/waybar/waybarThemes.nix
    ./home/themes/swayThemes.nix
  ];

}
