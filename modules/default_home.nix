{ config, pkgs, ...}:
{

  imports =
    [ # Unconditionally include the home modules
      ./home/gtk.nix
      ./home/swayidle.nix
      ./home/sway.nix
      ./home/waybar/waybar.nix
    ];

}
