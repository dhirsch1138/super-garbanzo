{ config, lib, pkgs, ... }:

{

  gtk = {
    enable = true;
    theme = {
      name = "rose-pine";
      package = pkgs.rose-pine-gtk-theme;
    };
    # so the theme option is just for gtk2 and gtk3?
    gtk4 = {
      theme = {
        name = "rose-pine";
        package = pkgs.rose-pine-gtk-theme;
      };
    };
    iconTheme = {
      name = "rose-pine-pine";
      package = pkgs.rose-pine-icon-theme;
    };
    cursorTheme = {
      name = "rose-pine-pine";
      package = pkgs.rose-pine-cursor;
    };
  };

}
