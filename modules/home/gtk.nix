{ config, lib, pkgs, ... }:

{

  gtk = {
    enable = false;
    theme = {
      name = "rose-pine";
      package = pkgs.rose-pine-gtk-theme;
    };
    iconTheme = {
      name = "rose-pine-icons";
      package = pkgs.rose-pine-icon-theme;
    };
    cursorTheme = {
      name = "rose-pine";
      package = pkgs.rose-pine-cursor;
    };
  };

}
