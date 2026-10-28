{
  config,
  lib,
  pkgs,
  ...
}:

# Sway window manager support module
# ---
# If the sway program module is enabled, this provides default configuration that supports the sway WM.
# The intent is that the configuration can just invoke:
#  programs.sway.enable = true;
# And automatically get the benefit of this supporting configuration, keeping the top level config clean.

let
in
{

  config = lib.mkIf config.programs.sway.enable {

    # List packages installed in system profile.
    # You can use https://search.nixos.org/ to find more packages (and options).
    environment.systemPackages = with pkgs; [
      mako
      wl-clipboard
    ];
    programs.sway = {
      wrapperFeatures.gtk = lib.mkDefault true;
    };
    # gsettings
    programs.dconf.enable = lib.mkDefault true;

    # GNOME Keyring is used to store secrets (like passwords)
    services.gnome.gnome-keyring.enable = lib.mkDefault true;

    # allow swaylock to (un)lock gnome keyring
    security.pam.services = {
      swaylock.enableGnomeKeyring = lib.mkDefault true;
      #  gdm.enableGnomeKeyring = true;
    };

    # enable tumbler for thumbnail generation in file managers like thunar
    services.tumbler.enable = lib.mkDefault true;

    # Thunar will serve as the GUI file manager for the sway session
    programs.thunar = {
      enable = lib.mkDefault true;
      plugins =
        with pkgs;
        lib.mkDefault [
          thunar-archive-plugin
          thunar-volman
        ];
    };

    # Enable xfconf to allow for thunar to work outside of xfce4 session.
    programs.xfconf.enable = lib.mkDefault true;

    # GNOME Virtual file service (for things like trash folder)
    services.gvfs.enable = lib.mkDefault true;
  };
}
