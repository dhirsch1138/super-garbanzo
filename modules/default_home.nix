{ config, pkgs, ...}:
{

  imports =
    [ # Unconditionally include the home modules
      ./home/waybar.nix
    ];

}
