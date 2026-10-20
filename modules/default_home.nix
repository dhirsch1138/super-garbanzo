{ config, pkgs, ...}:
{

  imports =
    [ # Unconditionally include the home modules
      ./home/swayidle.nix
      ./home/sway.nix
      ./home/waybar/waybar.nix
      ./home/waybar/waybarThemes.nix
      ./home/themes/swayThemes.nix
    ];

}
